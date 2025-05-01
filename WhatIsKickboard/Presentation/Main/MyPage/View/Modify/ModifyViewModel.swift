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
    case unknownError = "회원정보 수정을 실패하였습니다."
}

final class ModifyViewModel: ViewModelProtocol {
    enum Action {
        case name(String)
        case password(String, String)
        case withdrawal(String, String)
    }

    struct State {
        let nameStatus = PublishRelay<Void>()
        let passwordStatus = PublishRelay<Void>()
        let withDrawalStatus = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
    }

    private let actionSubject = PublishSubject<Action>()
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    let state = State()
    var user: User?
    let disposeBag = DisposeBag()

    init() {
        bind()
        loadUser()
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
                    Task {
                        try await owner.accessWithdrawalModify(password, passwordCheck)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 유저정보 불러오기
    func loadUser() {
        UserPersistenceManager.getUser()
            .subscribe(with: self, onSuccess: { owner, user in
                owner.user = user
            }, onFailure: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func accessNameModify(_ name: String) {
        guard !name.isEmpty else {
            state.errorMessage.accept(ModifyError.nameEmpty.rawValue)
            return
        }
        guard var user else { return }
        user.name = name
        
        UserPersistenceManager.patchUser(user)
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.nameStatus.accept(())
            }, onFailure: { owner, _ in
                owner.state.errorMessage.accept(ModifyError.unknownError.rawValue)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func accessPasswordModify(_ password: String, _ passwordCheck: String) {
        switch validatePassword(password, passwordCheck) {
        case .success:
            guard var user else { return }
            user.password = passwordCheck
            
            UserPersistenceManager.patchUser(user)
                .subscribe(with: self, onSuccess: { owner, user in
                    owner.state.passwordStatus.accept(())
                }, onFailure: { owner, _ in
                    owner.state.errorMessage.accept(ModifyError.unknownError.rawValue)
                })
                .disposed(by: disposeBag)
        case .failure(let error):
            state.errorMessage.accept(error.rawValue)
        }
    }

    private func accessWithdrawalModify(_ password: String, _ passwordCheck: String) async throws {
        switch validatePassword(password, passwordCheck) {
        case .success:
            do {
                try await UserPersistenceManager.deleteUser(password: passwordCheck)
                state.withDrawalStatus.accept(())
            } catch let error as UserPersistenceError {
                state.errorMessage.accept(error.rawValue)
            }
        case .failure(let error):
            state.errorMessage.accept(error.rawValue)
        }
    }
    
    private func validatePassword(_ password: String, _ passwordCheck: String) -> Result<Void, ModifyError> {
        if password.isEmpty {
            return .failure(.passwordEmpty)
        } else if passwordCheck.isEmpty || password != passwordCheck {
            return .failure(.passwordNotSame)
        } else {
            return .success(())
        }
    }
}
