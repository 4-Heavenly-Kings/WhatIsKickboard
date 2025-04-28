//
//  TabBarController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import SnapKit
import Then

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    //    private let tabBarHeight: CGFloat = SizeLiterals.Screen.screenHeight * 74 / 812
    private var tabControllers: [UIViewController] = []
    
    private var registerButton = UIButton()
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(RaisedTabBar(), forKey: "tabBar")   // 기본 탭바 교체
        
        //        setStyles()
        setupRegisterButton()
        
        setTabBarItems()
        //        setTabBarUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        tabBar.frame.size.height = self.tabBarHeight + getSafeAreaBottomHeight()
        setTabBarHeight()
    }
}

private extension TabBarController {
    func setTabBarItems() {
        let mapVC = UINavigationController(rootViewController: MyPageViewController())
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        
        let dummyVC = UIViewController()
        dummyVC.tabBarItem.isEnabled = false
        dummyVC.tabBarItem.title = nil
        dummyVC.tabBarItem.image = UIImage()
        
        tabControllers = [mapVC, dummyVC, myPageVC]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex:"#69C6D3")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.boldSystemFont(ofSize: 13)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex:"#69C6D3"),
            .font: UIFont.boldSystemFont(ofSize: 13)]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = appearance }
        
        TabBarItemType.allCases.forEach {
            let tabBarItem = $0.setTabBarItem()
            tabControllers[$0.rawValue].tabBarItem = tabBarItem
            tabControllers[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabControllers, animated: false)
    }
    
    // MARK: - 가운데 버튼
    private func setupRegisterButton() {
        let img = makeRegisterImage()   // 아래 함수
        registerButton.setBackgroundImage(img, for: .normal)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        tabBar.addSubview(registerButton)
        
        // ➊ 원 크기 (68pt)  ➋ 탭바 위로 ½ 정도 튀어나오게
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        //        let barHeight: CGFloat   = 80    // 탭바 고정 높이
        //        let circle: CGFloat      = 68    // 원형 지름
        //        let offset               = -(barHeight - circle) / 2
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            // ▶︎ 탭바의 ‘centerY’ 와 맞추면 세 아이콘 baseline이 동일
            registerButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -15),
            //   ↑ -4 정도 주면 텍스트가 살짝 내려가며 균형이 좋아집니다
            registerButton.widthAnchor.constraint(equalToConstant: 68),
            registerButton.heightAnchor.constraint(equalTo: registerButton.widthAnchor)
        ])
    }
    
    @objc private func didTapRegister() {
        selectedIndex = 1        // “등록”용 VC 를 띄우고 싶으면 modal presentation 등 원하는 대로
    }
    
    /// 검정 원 + 흰색 스쿠터 + "등록" 글자
    private func makeRegisterImage() -> UIImage {
        let wholeSize = CGSize(width: 68, height: 68)
        return UIGraphicsImageRenderer(size: wholeSize).image { _ in
            // 검정 원
            UIColor.black.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: wholeSize)).fill()
            
            // 아이콘
            let iconCfg = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
            let icon = UIImage(systemName: "scooter", withConfiguration: iconCfg)!
                .withTintColor(.white, renderingMode: .alwaysOriginal)
            
            let iconRect = CGRect(x: (wholeSize.width - 30) / 2, y: 10, width: 30, height: 30)
            icon.draw(in: iconRect)
            
            // 타이틀
            let text = "등록" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font : UIFont.boldSystemFont(ofSize: 13),
                .foregroundColor : UIColor.white
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: (wholeSize.width - textSize.width) / 2,
                y: iconRect.maxY + 2,
                width: textSize.width,
                height: textSize.height)
            text.draw(in: textRect, withAttributes: attrs)
        }
    }
    
    func setTabBarUI() {
        //        UITabBar.clearShadow()
        
        //        tabBar.backgroundColor = .white
        //        tabBar.tintColor = .gray
        //        tabBar.layer.masksToBounds = false
        //        tabBar.layer.shadowColor = UIColor.gray.cgColor
        //        tabBar.layer.shadowOpacity = 1
        //        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        tabBar.layer.shadowRadius = 0.3
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#69C6D3")
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(hex: "#69C6D3"),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .black
        tabBar.itemPositioning = .centered
        
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
        //        if let tabBar = self.tabBarController?.tabBar {
        //            let safeAreaBottomInset = self.view.safeAreaInsets.bottom
        //            let tabBarHeight = tabBar.bounds.height
        //            let newTabBarFrame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y, width: tabBar.frame.width, height: tabBarHeight + safeAreaBottomInset)
        //            tabBar.frame = newTabBarFrame
        //        }
        
        let height: CGFloat = 100  // 원하는 높이로 수정 (기본 49 → 80~90 추천)
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = view.frame.size.height - height
        tabBar.frame = tabFrame
    }
}
