//
//  SignUpViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

// MARK: - RegisterViewController
final class SignInViewController: BaseViewController {
    
    // MARK: - Components
    private let signInView = SignInView()
    
    override func loadView() {
        view = signInView
    }
}
