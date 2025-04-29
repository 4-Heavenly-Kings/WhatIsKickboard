//
//  EditNameViewModel.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - EditNameViewModel
final class EditNameViewModel: ViewModelProtocol {
    
    // MARK: - VC에서 방출하는 이벤트 액션 정의
    enum Action {
        case didTapConfirm(user: User)
    }
    
    // MARK: - 상태관리 프로퍼티
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var updateSuccess = PublishRelay<User>()
        fileprivate(set) var updateError = PublishRelay<Error>()
    }
    
    // MARK: - Action -> Observer 생성
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    var disposeBag = DisposeBag()
    var state = State()
    
    // MARK: - init시 이벤트에 따라 메서드 실행
    init() {
        state.actionSubject
            .subscribe(with: self){ owner, action in
                switch action {
                case let .didTapConfirm(user):
                    owner.confirm(user: user)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action에 따른 이벤트
    
    /// 이름 설정
    private func confirm(user: User) {
        guard let name = user.name, textFieldValidation(name: name) else { return }
        
        UserPersistenceManager.patchUser(user)
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.updateSuccess.accept(user)
            }, onFailure: { owner, error in
                owner.state.updateError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 내부에서만 동작되는 메서드 분리
extension EditNameViewModel {
    
    /// 텍스트 필드 유효성 검사
    private func textFieldValidation(name: String) -> Bool {
        if name.isEmpty {
            state.updateError.accept(UserPersistenceError.fieldIsEmpty)
            return false
        }
        return true
    }
}
