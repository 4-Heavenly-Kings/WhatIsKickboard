//
//  NameViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import Foundation

// MARK: - EditNameViewController
final class EditNameViewController: BaseViewController {
    
    // MARK: - Components
    private let editNameView = EditNameView()
    
    override func loadView() {
        view = editNameView
    }
}
