//
//  SplashViewController.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit

// MARK: - SplashViewController
final class SplashViewController: BaseViewController {
    
    // MARK: - Components
    private let splashView = SplashView()
    
    override func loadView() {
        view = splashView
    }
}
