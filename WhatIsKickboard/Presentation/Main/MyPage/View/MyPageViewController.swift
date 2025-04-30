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
    
    let myPageViewModel = MyPageViewModel()
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAction()
        bindUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - bindAction
    private func bindAction() {
        myPageViewModel.action.onNext(.viewDidLoad)
    }
    
    // MARK: - bindUIEvents
    private func bindUIEvents() {
        /// 이름 수정 (modifyNameButton)
        myPageView.myPageStackView.modifyNameButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(ModifyViewController(modityType: .name))
            }
            .disposed(by: disposeBag)
        
        /// 비밀번호 수정 (modifyPasswordButton)
        myPageView.myPageStackView.modifyPasswordButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(ModifyViewController(modityType: .password))
            }
            .disposed(by: disposeBag)
        
        /// 킥보드 등록 내역 (registerKickboard)
        myPageView.myPageStackView.registerKickboardButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(MyRegisterKickboardViewController())
            }
            .disposed(by: disposeBag)
        
        /// 이용 내역 (useDetailButton)
        myPageView.myPageStackView.useDetailButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(UseDetailViewController())
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
                guard let user = owner.user, let name = user.name else { return }
                
                let attributedText = NSMutableAttributedString.makeAttributedString(
                    text: "\(name)님, 안녕하세요!",
                    highlightedParts: [
                        (name, .core, UIFont.jalnan2(28)),
                        ("님, 안녕하세요!", .black, UIFont.jalnan2(28))
                    ]
                )
                owner.myPageView.pobyGreetingView.userNameGreetingLabel.attributedText = attributedText
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
        
    }
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
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
