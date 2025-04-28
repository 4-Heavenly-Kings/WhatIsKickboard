//
//  WhatIsKickboardTests.swift
//  WhatIsKickboardTests
//
//  Created by 백래훈 on 4/25/25.
//

import Testing
import Foundation
@testable import WhatIsKickboard

struct WhatIsKickboardTests {

    @Test func createUser() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        do {
            try await UserPersistenceManager.createUser(email, password)
            
            let fetchedUser = try UserPersistenceManager.getUser()
            #expect(fetchedUser.email == email)
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
    }
    
    @Test func login() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        do {
            try UserPersistenceManager.login(email, password)
            
            let fetchedUser = try UserPersistenceManager.getUser()
            #expect(fetchedUser.email == email)
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
    }
    

    @Test func getUser() async throws {
        do {
            let fetchedUser = try UserPersistenceManager.getUser()
            #expect(fetchedUser.email == fetchedUser.getMock().email)
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
    }

    @Test func patchUser() async throws {
        do {
            var fetchedUser = try UserPersistenceManager.getUser()
            fetchedUser.name = "포비"
            try await UserPersistenceManager.patchUser(fetchedUser)
            
            let updatedUser = try UserPersistenceManager.getUser()
            #expect(updatedUser.name == "포비")
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
    }

    @Test func deleteUser() async throws {
        do {
            try await UserPersistenceManager.deleteUser(password: "password123")
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
        
        do {
            try UserPersistenceManager.getUser()
        } catch {
            #expect(true)
        }
    }
    
    @Test func testLogOut() async throws {
        UserPersistenceManager.logout()
        let token = UserDefaults.standard.string(forKey: "token")
        #expect(token == nil)
    }
}
