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
    
    let myPageViewModel = MyPageViewModel()
    
    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - bindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
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
        
        /// 내가 등록한 킥보드 (registerKickboard)
        myPageView.myPageStackView.useDetailButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(UseDetailViewController())
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
        
        alert.configure(name: "회원님", minutes: nil, count: nil, price: nil)
        
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
    
    private func showWithdrawalAlert() {
        let alert = CustomAlertView(frame: .zero, alertType: .deleteID)
        view.addSubview(alert)
        
        alert.configure(name: "회원님", minutes: nil, count: nil, price: nil)
        
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
