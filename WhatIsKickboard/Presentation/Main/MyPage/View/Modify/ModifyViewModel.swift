//
//  ModifyViewModel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import Foundation

import RxSwift
import RxRelay

enum ModifyError: String, Error {
    case nameEmpty = "빈 값으로는 변경할 수 없습니다."
    case passwordEmpty = "비밀번호를 입력해주세요."
    case passwordNotSame = "비밀번호를 확인해주세요."
}

final class ModifyViewModel: ViewModelProtocol {
    enum Action {
        case name(String)
        case password(String, String)
        case withdrawal(String, String)
    }

    struct State {
        let nameStatus = PublishSubject<User>()
        let passwordStatus = PublishSubject<User>()
        let withDrawalStatus = PublishSubject<String>()
    }

    private let actionSubject = PublishSubject<Action>()
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()

    init() {
        bind()
    }
    
    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .name(let name):
                    owner.accessNameModify(name)
                case .password(let password, let passwordCheck):
                    owner.accessPasswordModify(password, passwordCheck)
                case .withdrawal(let password, let passwordCheck):
                    owner.accessWithdrawalModify(password, passwordCheck)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func accessNameModify(_ name: String) {
        if name.isEmpty {
            state.nameStatus.onError(ModifyError.nameEmpty)
        } else {
            // API 호출 후 onNext 필요 (patchUser)
//            state.nameStatus.onNext(<#T##element: User##User#>)
        }
    }
    
    private func accessPasswordModify(_ password: String, _ passwordCheck: String) {
        if password.isEmpty {
            state.passwordStatus.onError(ModifyError.passwordEmpty)
        } else if
            (!password.isEmpty && passwordCheck.isEmpty) ||
            (password != passwordCheck) {
            state.passwordStatus.onError(ModifyError.passwordNotSame)
        } else if password == passwordCheck {
            // API 호출 후 onNext 필요 (patchUser)
//            state.passwordStatus.onNext(<#T##element: User##User#>)
        }
    }
    
    private func accessWithdrawalModify(_ password: String, _ passwordCheck: String) {
        if password.isEmpty {
            state.passwordStatus.onError(ModifyError.passwordEmpty)
        } else if
            (!password.isEmpty && passwordCheck.isEmpty) ||
            (password != passwordCheck) {
            state.passwordStatus.onError(ModifyError.passwordNotSame)
        } else if password == passwordCheck {
            // API 호출 후 onNext 필요 (patchUser)
//            state.passwordStatus.onNext(<#T##element: User##User#>)
        }
    }
}
