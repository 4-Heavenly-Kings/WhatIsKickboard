//
//  Empty2.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import Foundation

// MARK: User + Mapper
extension UserEntity {
    func toModel() -> User {
        return User(id: self.id!, email: self.email!, password: self.password!, name: self.name, role: self.role!)
    }
}
