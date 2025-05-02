//
//  CustomAlertViewType.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

enum CustomAlertViewType {
    case returnRequest
    case confirmReturn
    case logout
    case deleteID
    case emailFailed
    case signIntFailed
    case failureUserModify
    case batteryInputFailed
    case failCreateKickboard
    case successCreateKickboard
    
    func makeTitle(name: String, minutes: Int? = nil, count: Int? = nil) -> NSAttributedString {
        let fullText: String
        
        switch self {
        case .returnRequest:
            if let minutes = minutes {
                fullText = "\(name)님은 지금까지 포비와 \(minutes)분 달렸어요"
            } else {
                fullText = "\(name)님은 포비와 함께했어요"
            }
        case .confirmReturn:
            fullText = "킥보드는 안전하게 포비에게 다시 돌아갔습니다."
        case .logout, .deleteID:
            if let count = count {
                fullText = "\(name)님은 지금까지 포비와 \(count)번 달렸어요"
            } else {
                fullText = "\(name)님은 아직 포비와 달린적이 없어요"
            }
        case .emailFailed, .signIntFailed, .failureUserModify:
            fullText = name
        case .batteryInputFailed:
            fullText = "0~100 사이의 값을 입력해주세요"
        case .failCreateKickboard:
            fullText = "킥보드 등록을 실패했습니다"
        case .successCreateKickboard:
            fullText = "킥보드 등록을 성공했습니다"
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let nameRange = fullText.range(of: name) {
            let nsRange = NSRange(nameRange, in: fullText)
            attributedString.addAttributes([
                .foregroundColor: UIColor(hex: "#69C6D3"),
                .font: UIFont.boldSystemFont(ofSize: 20)
            ], range: nsRange)
        }
        
        if let number = minutes ?? count {
            let numberString = "\(number)"
            if let numberRange = fullText.range(of: numberString) {
                let nsRange = NSRange(numberRange, in: fullText)
                attributedString.addAttributes([
                    .foregroundColor: UIColor(hex: "#000000"),
                    .font: UIFont.boldSystemFont(ofSize: 20)
                ], range: nsRange)
            }
        }
        
        return attributedString
    }
    
    func makeSubtitle(price: String? = nil) -> String {
        switch self {
        case .returnRequest:
            if let price {
                return "이제 포비와 그만 달릴까요?\n총 금액: \(price)원"
            } else {
                return "이제 포비와 그만 달릴까요?"
            }
        case .confirmReturn, .batteryInputFailed, .failCreateKickboard, .successCreateKickboard:
            return ""
        case .logout:
            return "이제 그만 로그아웃 할까요?"
        case .deleteID:
            return "어디가~? 킥보드 말고 뭐 타려고~?"
        case .emailFailed, .signIntFailed:
            return ""
        case .failureUserModify:
            return "다시 시도해줄래~?"
        }
    }
    
    var submitTitle: String {
        switch self {
        case .returnRequest: return "포비와 그만 놀기"
        case .confirmReturn, .emailFailed, .signIntFailed, .failureUserModify, .batteryInputFailed, .failCreateKickboard, .successCreateKickboard: return "확인"
        case .logout: return "로그아웃"
        case .deleteID: return "포비에게 도망가기"
        }
    }
    
    var submitTitleColor: UIColor {
        switch self {
        case .returnRequest, .confirmReturn, .deleteID, .emailFailed, .signIntFailed, .failureUserModify, .batteryInputFailed, .failCreateKickboard, .successCreateKickboard: return UIColor(hex: "#6B6E82")
        case .logout: return UIColor(hex: "#FF4F17")
        }
    }
    
    var cancelTitle: String {
        switch self {
        case .returnRequest: return "더 달리기"
        case .confirmReturn, .emailFailed, .signIntFailed, .batteryInputFailed, .failCreateKickboard, .successCreateKickboard: return ""
        case .logout, .failureUserModify: return "취소"
        case .deleteID: return "포비와 더 달리기"
        }
    }
    
    var cancelTitleColor: UIColor {
        return UIColor(hex: "#69C6D3")
    }
}
