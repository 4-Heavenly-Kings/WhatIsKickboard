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
    let myPageView = MyPageView()
    
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
    }
    
    // MARK: - bindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        /// 이름 수정 (modifyNameButton)
        myPageView.myPageStackView.modifyNameButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.pushNavigationController(UseDetailViewController())
            }
            .disposed(by: disposeBag)
        
        /// 비밀번호 수정 (modifyPasswordButton)
        myPageView.myPageStackView.modifyPasswordButton.rx.tap
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
                owner.myPageViewModel.action
                    .onNext(.logoutAction)
            }
            .disposed(by: disposeBag)
        
        /// 회원탈퇴 (withDrawalButton)
        myPageView.withDrawalButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.myPageViewModel.action
                    .onNext(.withDrawalAction)
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
    
}
