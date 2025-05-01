//
//  ReturnViewModel.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import Foundation

import RxSwift
import RxRelay

final class ReturnViewModel: ViewModelProtocol {

    enum Action {

    }

    struct State {

    }

    private let actionSubject = PublishSubject<Action>()
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {

    }
    

}
