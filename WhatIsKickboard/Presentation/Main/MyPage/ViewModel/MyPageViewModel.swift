//
//  MyPageViewModel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import Foundation

import RxSwift
import RxRelay
import CoreData
import UIKit

final class MyPageViewModel: ViewModelProtocol {

    enum Action {
        case viewWillAppear
        case logoutAction
        case withDrawalAction
    }

    struct State {
        let user = PublishSubject<User>()
        let accessLogout = PublishRelay<Void>()
        let accessWithDrawal = PublishRelay<Void>()
    }

    private let actionSubject = PublishSubject<Action>()
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()
    
    let modifyUseCase: ModifyUseCase
    
    var container: NSPersistentContainer!

    init(modifyUseCase: ModifyUseCase) {
        self.modifyUseCase = modifyUseCase
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewWillAppear:
                    owner.loadUser()
                case .logoutAction:
                    owner.logoutProgress()
                case .withDrawalAction:
                    owner.withDrawalProgress()
                }
            }
            .disposed(by: disposeBag)
        
//        Task {
//            for _ in 0..<10 {
//                try await KickboardPersistenceManager.createKickboard(latitude: 37.498061, longitude: 127.028759, battery: 77, address: "서울특별시 강남구 도산대로 23길")
//            }
//        }
        
    }
}

//MARK: - Extension Private Methods
private extension MyPageViewModel {
    
    /// 유저정보 불러오기
    func loadUser() {
        modifyUseCase.getUser()
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.user.onNext(user)
            }, onFailure: { owner, error in
                owner.state.user.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 로그아웃 처리하기
    func logoutProgress() {
        state.accessLogout.accept(())
    }
    
    /// 회원탈퇴 처리하기
    func withDrawalProgress() {
        state.accessWithDrawal.accept(())
    }
}
