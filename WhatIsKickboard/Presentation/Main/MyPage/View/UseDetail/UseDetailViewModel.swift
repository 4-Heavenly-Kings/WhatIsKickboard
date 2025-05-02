//
//  UseDetailViewModel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//


import UIKit

import RxSwift
import RxCocoa

final class UseDetailViewModel: ViewModelProtocol {
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        let useDetailList = PublishRelay<[KickboardRide]>()
        let errorMessage = PublishRelay<String>()
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
                    if let idString = UserDefaults.standard.string(forKey: "token"),
                       let id = UUID(uuidString: idString) {
                        owner.fetchKickboardList(userId: id)
                    } else {
                        owner.state.errorMessage.accept(KickboardPersistenceError.tokenNotValid.rawValue)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension UseDetailViewModel {
    func fetchKickboardList(userId: UUID) {
        listUseCase.getKickboardRideList(userId: userId)
            .subscribe(with: self) { owner, kickboardRideList in
                print("getKickboardRideList 호출 성공")
                print("CoreData 이용 내역리스트: \(kickboardRideList)")
                
//                print("MockData 킥보드 리스트: \(KickboardRide.getMockList(userId: userId))")
                
                // 여기서 MockData가 아닌 CoreData를 넘겨줘야함
//                owner.state.useDetailList.accept(KickboardRide.getMockList(userId: userId))
                owner.state.useDetailList.accept(kickboardRideList)
            } onFailure: { owner, error in
                print("getKickboardList 호출 실패")
            }
            .disposed(by: disposeBag)

    }
}
