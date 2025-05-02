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
    
    /// 이미지 속성 설정 후 VC이동
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showMainView()
        }
    }
    
    /// VC 네비게이션 설정
    private func showMainView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let tabbarVC = TabBarController()
        tabbarVC.modalTransitionStyle = .crossDissolve
        
        // 애니메이션 효과를 위해 UIView transition 사용
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
            window.rootViewController = tabbarVC
        }
    }
}
