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
    
    private let listUseCase: ListUseCase
    
    init(listUseCase: ListUseCase) {
        self.listUseCase = listUseCase
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
        listUseCase.getKickboardList()
            .subscribe(with: self) { owner, kickboardList in
                print("getKickboardList 호출 성공")
                print("CoreData 킥보드 리스트: \(kickboardList)")
                
                let kickboad = Kickboard(id: UUID(),
                                         latitude: 128.12,
                                         longitude: 37.33,
                                         battery: 30,
                                         address: "서울시",
                                         status: "ABLE")
                
                print("MockData 킥보드 리스트: \(kickboad.getMockList())")
                
                // 여기서 MockData가 아닌 CoreData를 넘겨줘야함
                owner.state.kickboardList.accept(kickboad.getMockList())
            } onFailure: { owner, error in
                print("getKickboardList 호출 실패")
            }
            .disposed(by: disposeBag)

    }
}
