//
//  TabBarController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    private var tabControllers: [UIViewController] = []
    /// 탭바 중앙의 등록 버튼
    private let registerButton = UIButton()
    /// 탭바의 라운드 곡선 처리를 위한 View
    private let tabBackgroundView = UIView()
    /// 직전에 표시했던 ViewController의 index 저장
    private var previousIndex: Int = 0
    
    private let viewModel = TabbarViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyles()
        setLayouts()
        setDelegates()
        
        setTabBarItems()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBarHeight()
        viewModel.action.onNext(.viewDidLoad)
    }
    
    func setStyles() {
        registerButton.do {
            let img = makeRegisterImage()
            $0.setBackgroundImage(img, for: .normal)
            $0.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        }
        
        tabBackgroundView.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.masksToBounds = true
        }
    }
    
    func setLayouts() {
        // 탭바 위에 올려야 하므로 insertSubview(_:, at:)
        tabBar.insertSubview(tabBackgroundView, at: 0)
        tabBar.addSubview(registerButton)
        
        tabBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-12)
            $0.width.equalTo(80)
            $0.height.equalTo(registerButton.snp.width)
        }
    }
    
    func setDelegates() {
        self.delegate = self
    }
    
    func bindViewModel() {
        viewModel.state.user
            .subscribe(with: self, onNext: { _, user in
                print("유저정보 조희 성공 \(user)")
            }, onError: { owner, error in
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

private extension TabBarController {
    /// iOS 15 이상에서의 탭바 변경을 위한 Appearance 설정
    func makeTabBarAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 14, weight: .black)
        ]
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = .init(horizontal: 0, vertical: 3)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex:"#69C6D3")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex:"#69C6D3"),
            .font: UIFont.systemFont(ofSize: 14, weight: .black)
        ]
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = .init(horizontal: 0, vertical: 3)
        
        return appearance
    }
    
    /// 지도, 등록, 마이페이지 탭바 아이템 설정
    /// (여기서 '등록'은 dummy로 선언)
    func setTabBarItems() {
//        let repository = ReturnRequestRepository()
//        let useCaseInterface = ReturnRequestUseCase(repository: repository)
//        let viewModel = TestViewModel(returnRequestUseCaseInterface: useCaseInterface)
//        let vc = testViewController(viewModel: viewModel)
//        
//        
        
        
        let apiGeocodingRepository = APIGeocodingRepository()
        let rentKickboardrepository = RentKickboardRepository()
        let returnRequestRepository = ReturnRequestRepository()
    
        let fetchAPIGeocodingUseCase = FetchAPIGeocodingUseCase(repository: apiGeocodingRepository)
        let rentKickboardUseCase = RentKickboardUseCase(repository: rentKickboardrepository)
        let returnRequestUseCase = ReturnRequestUseCase(repository: returnRequestRepository)
        let viewModel = MapTabViewModel(fetchAPIGeocodingUseCase: fetchAPIGeocodingUseCase, rentKickboardUseCase: rentKickboardUseCase, returnRequestUseCaseInterface: returnRequestUseCase)
        let mapTabViewController = MapTabViewController(viewModel: viewModel)
        mapTabViewController.changeSelectedIndexDelegate = self
        
        let mapVC = UINavigationController(rootViewController: mapTabViewController)
        let registerVC = UIViewController()
        
        // 의존성 주입 코드로 변경 (현재는 DIContainer X)
        let modifyRepository = ModifyRepository()
        let modifyUseCase = ModifyUseCase(repository: modifyRepository)
        let myPageViewModel = MyPageViewModel(modifyUseCase: modifyUseCase)
        let myPageVC = UINavigationController(rootViewController: MyPageViewController(myPageViewModel: myPageViewModel))
        
        tabControllers = [mapVC, registerVC, myPageVC]
        
        let appearance = makeTabBarAppearance()
        tabBar.standardAppearance = appearance
        tabBar.itemPositioning = .automatic
        
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        TabBarItemType.allCases.forEach {
            let tabBarItem = $0.setTabBarItem()
            tabControllers[$0.rawValue].tabBarItem = tabBarItem
            tabControllers[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabControllers, animated: false)
    }
    
    /*
     현재는 버튼 클릭 시 Index 변화없이 위 setTabBarItems 함수에서 보이는 dummyVC 만을 띄우고 있음
     추후 navigation push를 활용하여 킥보드 등록 화면으로 넘어가게끔 구현하면 될듯함
     */
    @objc private func didTapRegister() {
//        selectedIndex = 1
    }
    
    /// 검정 원 + 흰색 스쿠터 + "등록" 글자를 위한 메서드
    private func makeRegisterImage() -> UIImage {
        let wholeSize = CGSize(width: 80, height: 80)
        return UIGraphicsImageRenderer(size: wholeSize).image { _ in
            // 검정 원
            UIColor.black.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: wholeSize)).fill()
            
            // 아이콘
            let iconCfg = UIImage.SymbolConfiguration(pointSize: 40, weight: .heavy)
            let icon = UIImage(systemName: "scooter", withConfiguration: iconCfg)!
                .withTintColor(.white, renderingMode: .alwaysOriginal)
            
            let iconRect = CGRect(x: (wholeSize.width - 40) / 2, y: 15, width: 40, height: 30)
            icon.draw(in: iconRect)
            
            // 타이틀
            let text = "등록" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font : UIFont.systemFont(ofSize: 16, weight: .black),
                .foregroundColor : UIColor.white
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (wholeSize.width - textSize.width) / 2,
                y: iconRect.maxY + 5,
                width: textSize.width,
                height: textSize.height)
            text.draw(in: textRect, withAttributes: attrs)
        }
    }
    
    func getSafeAreaBottomHeight() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let safeAreaInsets = windowScene.windows.first?.safeAreaInsets
            let bottomSafeAreaHeight = safeAreaInsets?.bottom ?? 0
            return bottomSafeAreaHeight
        }
        return 0
    }
    
    func setTabBarHeight() {
        let height: CGFloat = 105       // 탭 바의 높이 (105)
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = view.frame.size.height - height
        tabBar.frame = tabFrame
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    // MapTabViewController를 찾아 킥보드 위치 등록 상태로 전환시킴
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        if index == 1 {
            if let nav = viewControllers?[0] as? UINavigationController,
               let mapVC = nav.viewControllers.first as? MapTabViewController {
                selectedIndex = 0
                mapVC.isRegister = true
            }
        } else {
            previousIndex = index
        }
    }
}

// MARK: - ChangeSelectedIndexDelegate

extension TabBarController: ChangeSelectedIndexDelegate {
    func changeSelectedIndexToPrevious() {
        UIView.performWithoutAnimation {
            selectedIndex = previousIndex
        }
    }
}
