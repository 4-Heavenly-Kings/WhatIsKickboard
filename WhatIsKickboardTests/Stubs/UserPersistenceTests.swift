//
//  WhatIsKickboardTests.swift
//  WhatIsKickboardTests
//
//  Created by 백래훈 on 4/25/25.
//

import Testing
import Foundation
@testable import WhatIsKickboard

// MARK: - UserPersistenceTests
struct UserPersistenceTests {

    /// 회원가입 테스트
    @Test func testCreateUser() async throws {
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
    
    /// 로그인 테스트
    @Test func testLogin() async throws {
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
    
    /// 유저정보 조회 테스트
    @Test func testGetUser() async throws {
        do {
            let fetchedUser = try UserPersistenceManager.getUser()
            #expect(fetchedUser.email == fetchedUser.getMock().email)
        } catch let error as UserPersistenceError {
            print(error.rawValue)
            #expect(Bool(false))
        }
    }

    /// 유저정보 수정 테스트
    @Test func testPatchUser() async throws {
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
    
    /// 유저정보 삭제 테스트
    @Test func testDeleteUser() async throws {
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
    
    // 로그아웃 테스트
    @Test func testLogOut() async throws {
        UserPersistenceManager.logout()
        let token = UserDefaults.standard.string(forKey: "token")
        #expect(token == nil)
    }
}
