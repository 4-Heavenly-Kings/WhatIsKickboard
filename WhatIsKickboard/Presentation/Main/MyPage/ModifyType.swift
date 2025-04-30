//
//  ModifyType.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import Foundation

enum ModifyType: String {
    case name
    case password
    
    var navigationTitle: String {
        switch self {
        case .name:
            return "이름 수정"
        case .password:
            return "비밀번호 수정"
        }
    }
    
    var placeholder: String {
        switch self {
        case .name:
            return "이름 수정"
        case .password:
            return "비밀번호"
        }
    }
}
