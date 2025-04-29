//
//  RegisterViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class RegisterViewController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    
    private let contentView = RegisterView()

    
    // MARK: - View Life Cycle

    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindViewModel() {
        contentView.navigationBarView.getBackButton().rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                print("did Tap back Button")
            }
            .disposed(by: disposeBag)
        
        contentView.navigationBarView.getRightButton().rx.tap
            .bind { [weak self] in
                print("저장버튼")
            }
            .disposed(by: disposeBag)
        

    }

    override func setStyles() {
        contentView.navigationBarView.configure(title: "킥보드 정보 설정", showsRightButton: true, rightButtonTitle: "저장")
        contentView.registerStackView.configure(location: "서울 구로구")
    }
    
    override func setLayout() {

    }
}
