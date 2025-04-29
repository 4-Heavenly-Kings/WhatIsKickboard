//
//  NameViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import Foundation

// MARK: - EditNameViewController
final class EditNameViewController: BaseViewController {
    
    // MARK: - Components
    private let editNameView = EditNameView()
    private let viewModel = EditNameViewModel()
    var user: User?
    
    override func loadView() {
        view = editNameView
    }
    
    override func bindViewModel() {
        /// 이름 설정 버튼 이벤트 방출
        editNameView.getConfirmButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                let name = owner.editNameView.getNameTextField.text ?? ""
                return (owner, name)
            }
            .bind { owner, name in
                owner.user?.name = name
                guard let user = owner.user else { return }
                owner.viewModel.action.onNext(.didTapConfirm(user: user))
            }
            .disposed(by: disposeBag)
        
        /// 이름 설정 성공 이벤트 구독
        viewModel.state.updateSuccess
            .subscribe(with: self, onNext: { owner, user in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 이름 설정 실패 이벤트 구독
        viewModel.state.updateError
            .subscribe(with: self, onNext: { owner, error in
                guard let error = error as? UserPersistenceError else { return }
                owner.editNameView.showAlert(text: error.rawValue)
            })
            .disposed(by: disposeBag)
    }
}
