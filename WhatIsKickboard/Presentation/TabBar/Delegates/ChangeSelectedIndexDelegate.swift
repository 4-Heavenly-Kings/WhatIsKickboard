//
//  ChangeSelectedIndexDelegate.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

/// MapTabViewController ➡️ TabBarController
protocol ChangeSelectedIndexDelegate: AnyObject {
    /// TabBarController가 직전에 표시했던 ViewController를 표시하도록 함
    func changeSelectedIndexToPrevious()
}
