//
//  ModifyRepository.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

final class ModifyRepository: ModifyRepositoryInterface {
    func getUser() -> Single<User> {
        UserPersistenceManager.getUser()
    }
    
    func patchUser(user: User) -> Single<User> {
        UserPersistenceManager.patchUser(user)
    }
    
    func deleteUser(password: String) async throws {
        do {
            try await UserPersistenceManager.deleteUser(password: password)
        } catch let error as UserPersistenceError {
            print("ModifyRepository deleteUser error: \(error.rawValue)")
        }
    }
    
}
