//
//  RaisedTabBar.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

final class RaisedTabBar: UITabBar {
    /// 원형(68) + 내부 마진 12 + 안전영역
    private let barHeight: CGFloat = 80

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = barHeight + safeAreaInsets.bottom
        return newSize
    }
}
