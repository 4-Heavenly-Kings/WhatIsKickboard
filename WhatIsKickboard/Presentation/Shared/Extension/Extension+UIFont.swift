//
//  Extension+UIFont.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit

// MARK: 커스텀 폰트 적용
extension UIFont {
    
    static func jalnan2(_ size: CGFloat) -> Self {
        return UIFont(name: "Jalnan2", size: size) as! Self
    }
    
    static func jalnan2TTF(_ size: CGFloat) -> Self {
        return UIFont(name: "Jalnan2TTF", size: size) as! Self
    }
}
