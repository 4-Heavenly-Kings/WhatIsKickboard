//
//  ModifyRepositoryInterface.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

protocol ModifyRepositoryInterface {
    func getUser() -> Single<User>
    func patchUser(user: User) -> Single<User>
    func deleteUser(password: String) async throws
}
