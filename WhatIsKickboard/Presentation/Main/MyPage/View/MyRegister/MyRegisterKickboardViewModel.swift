//
//  MyRegisterKickboardViewModel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyRegisterKickboardViewModel: ViewModelProtocol {
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        let kickboardList = PublishRelay<[Kickboard]>()
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
                case .viewDidLoad:
                    owner.fetchKickboardList()
                }
            }
            .disposed(by: disposeBag)
    }
    
}

private extension MyRegisterKickboardViewModel {
    func fetchKickboardList() {
        KickboardPersistenceManager.getKickboardList()
            .subscribe(with: self) { owner, kickboardList in
                print("getKickboardList 호출 성공")
                print("킥보드 리스트: \(kickboardList)")
            } onFailure: { owner, error in
                print("getKickboardList 호출 실패")
            }
            .disposed(by: disposeBag)

    }
}
