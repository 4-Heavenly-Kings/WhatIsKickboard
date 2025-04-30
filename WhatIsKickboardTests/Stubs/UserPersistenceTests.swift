//
//  WhatIsKickboardTests.swift
//  WhatIsKickboardTests
//
//  Created by 백래훈 on 4/25/25.
//

import Testing
import RxSwift
import Foundation
@testable import WhatIsKickboard

// MARK: - UserPersistenceTests
struct UserPersistenceTests {

    var disposeBag = DisposeBag()
    /// 회원가입 테스트
    @Test func testCreateUser() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        UserPersistenceManager.createUser(email, password)
            .subscribe(onSuccess: { user in
                getUser { user in
                    #expect(user.email == email)
                }
            }, onFailure: { error in
                print(error.localizedDescription)
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
    
    /// 로그인 테스트
    @Test func testLogin() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        UserPersistenceManager.login(email, password)
            .subscribe(onSuccess: { user in
                getUser { user in
                    #expect(user.email == email)
                }
            }, onFailure: { error in
                print(error.localizedDescription)
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
    
    /// 유저정보 조회 테스트
    @Test func testGetUser() async throws {
        getUser { user in
            #expect(user.email == user.getMock().email)
        }
    }

    /// 유저정보 수정 테스트
    @Test func testPatchUser() async throws {
        getUser { user in
            var user = user
            user.name = "포비"
            UserPersistenceManager.patchUser(user)
                .subscribe(onSuccess: { user in
                    getUser { user in
                        #expect(user.name == "포비")
                    }
                }, onFailure: { error in
                    print(error.localizedDescription)
                    #expect(Bool(false))
                })
                .disposed(by: disposeBag)
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
        getUser(expect: true) { _ in
            #expect(Bool(false))
        }
    }
    
    // 로그아웃 테스트
    @Test func testLogOut() async throws {
        UserPersistenceManager.logout()
        let token = UserDefaults.standard.string(forKey: "token")
        #expect(token == nil)
    }
}

// MARK: - 테스트가 아닌 메서드
extension UserPersistenceTests {
    // 킥보드 반환 핸들링
    private func getUser(expect: Bool = false, completion: @escaping (User) -> Void) {
        UserPersistenceManager.getUser()
            .subscribe(onSuccess: { user in
                completion(user)
            }, onFailure: { error in
                print(error.localizedDescription)
                #expect(Bool(expect))
            })
            .disposed(by: disposeBag)
    }
}
