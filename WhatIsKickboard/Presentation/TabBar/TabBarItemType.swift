//
//  TabBarItemType.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case map
    case register
    case myPage
}

extension TabBarItemType {
    var title: String {
        switch self {
        case .map:
            return "지도"
        case .register:
            return ""
        case .myPage:
            return "마이페이지"
        }
    }
    
    var unSelectedIcon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        switch self {
        case .map:
            return UIImage(systemName: "map", withConfiguration: config)!
        case .register:
            return UIImage()
        case .myPage:
            return UIImage(systemName: "person.crop.circle", withConfiguration: config)!
        }
    }
    
    var selectedIcon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        switch self {
        case .map:
            return UIImage(systemName: "map.fill", withConfiguration: config)!
        case .register:
            return UIImage()
        case .myPage:
            return UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)!
        }
    }
    
    func setTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: self.title, image: unSelectedIcon, selectedImage: selectedIcon)
    }
}
