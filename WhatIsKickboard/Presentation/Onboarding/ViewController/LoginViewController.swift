//
//  LoginViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

// MARK: - LoginViewController
final class LoginViewController: UIViewController {
    
    // MARK: - Components
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
}
