//
//  MyPageViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

//MARK: - MyPageViewController
final class MyPageViewController: BaseViewController {
    
    // MARK: - Components
    private let myPageView = MyPageView()
    private var customAlertView: CustomAlertView?
    
    // MARK: - Properties
    private var user: User?
    
    let myPageViewModel: MyPageViewModel
    
    init(myPageViewModel: MyPageViewModel) {
        self.myPageViewModel = myPageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        bindAction()
    }
    
    // MARK: - bindAction
    private func bindAction() {
        myPageViewModel.action.onNext(.viewWillAppear)
    }
    
    // MARK: - bindUIEvents
    private func bindUIEvents() {
        /// 이름 수정 (modifyNameButton)
        myPageView.myPageStackView.modifyNameButton.rx.tap
            .subscribe(with: self) { owner, _ in
                
                owner.pushNavigationController(ModifyViewController(modityType: .name, modifyViewModel: owner.setModifyViewModel(modifyType: .name)))
            }
            .disposed(by: disposeBag)
        
        /// 비밀번호 수정 (modifyPasswordButton)
        myPageView.myPageStackView.modifyPasswordButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(ModifyViewController(modityType: .password, modifyViewModel: owner.setModifyViewModel(modifyType: .password)))
            }
            .disposed(by: disposeBag)
        
        /// 킥보드 등록 내역 (registerKickboard)
        myPageView.myPageStackView.registerKickboardButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let listRepository = ListRepository()
                let listUsecase = ListUseCase(repository: listRepository)
                owner.pushNavigationController(MyRegisterKickboardViewController(viewModel: MyRegisterKickboardViewModel(listUseCase: listUsecase)))
            }
            .disposed(by: disposeBag)
        
        /// 이용 내역 (useDetailButton)
        myPageView.myPageStackView.useDetailButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let listRepository = ListRepository()
                let listUsecase = ListUseCase(repository: listRepository)
                owner.pushNavigationController(UseDetailViewController(viewModel: UseDetailViewModel(listUseCase: listUsecase)))
            }
            .disposed(by: disposeBag)
        
        /// 로그아웃 (logoutButton)
        myPageView.myPageStackView.logoutButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showLogoutAlert()
                owner.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)
        
        /// 회원탈퇴 (withDrawalButton)
        myPageView.withDrawalButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.showWithdrawalAlert()
                owner.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - bindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        /// 회원정보 보여주기
        myPageViewModel.state.user
            .subscribe(with: self, onNext: { owner, user in
                owner.user = user
                owner.myPageView.removeComponents()
                // 현재 유저의 상태를 보여주기 (킥보드 이용 or 이용 X)
                if user.currentKickboardRideId != nil {
                    owner.myPageView.kickboardUsingLayout()
                    owner.myPageView.kickboardUsingconfigure(user: user)
                } else {
                    owner.myPageView.pobyGreetingLayout()
                    owner.myPageView.pobyGreetingConfigure(user: user)
                }
            }, onError: { owner, error in
                print("\(owner.className) 유저 정보를 찾을 수 없습니다!")
            })
            .disposed(by: disposeBag)
        
        /// 최종적으로 AlertView에서 로그아웃 버튼이 눌린 경우
        myPageViewModel.state.accessLogout
            .bind(with: self) { owner, _ in
                UserPersistenceManager.logout()
                SceneDelegate.switchToSplash()
            }
            .disposed(by: disposeBag)
        
        /// 최종적으로 AlertView에서  버튼이 눌린 경우
        myPageViewModel.state.accessLogout
            .bind(with: self) { owner, _ in
                UserPersistenceManager.logout()
                SceneDelegate.switchToSplash()
            }
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
    }
    
    private func setModifyViewModel(modifyType: ModifyType) -> ModifyViewModel {
        let modifyRepository = ModifyRepository()
        let modifyUseCase = ModifyUseCase(repository: modifyRepository)
        let modifyViewModel = ModifyViewModel(modifyUseCase: modifyUseCase)

        return modifyViewModel
    }
    
    private func pushNavigationController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showLogoutAlert() {
        let alert = CustomAlertView(frame: .zero, alertType: .logout)
        view.addSubview(alert)
        
        guard let user, let name = user.name else { return }
        
        alert.configure(name: name)
        
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert.getSubmitButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
                 owner.myPageViewModel.action.onNext(.logoutAction)
            }
            .disposed(by: disposeBag)
        
        alert.getCancelButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func showWithdrawalAlert() {
        let alert = CustomAlertView(frame: .zero, alertType: .deleteID)
        view.addSubview(alert)
        
        guard let user, let name = user.name else { return }
        
        alert.configure(name: name)
        
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert.getSubmitButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
                owner.pushNavigationController(ModifyViewController(modityType: .withdrawal, modifyViewModel: owner.setModifyViewModel(modifyType: .withdrawal)))
            }
            .disposed(by: disposeBag)
        
        alert.getCancelButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func dismissAlertView(_ alert: CustomAlertView) {
        alert.removeFromSuperview()
        self.customAlertView = nil
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
