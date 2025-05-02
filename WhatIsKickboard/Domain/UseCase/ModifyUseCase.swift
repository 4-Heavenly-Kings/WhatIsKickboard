//
//  ModifyUseCase.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

final class ModifyUseCase: ModifyUseCaseInterface {
    
    let repository: ModifyRepositoryInterface
    
    init(repository: ModifyRepositoryInterface) {
        self.repository = repository
    }
    
    func getUser() -> Single<User> {
        return repository.getUser()
    }
    
    func patchUser(user: User) -> Single<User> {
        return repository.patchUser(user: user)
    }
    
    func deleteUser(password: String) async throws {
        do {
            try await repository.deleteUser(password: password)
        } catch let error as UserPersistenceError {
            print("ModifyRepository deleteUser error: \(error.rawValue)")
        }
    }
}
