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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.showMainView()
        }
    }
    
    /// VC 네비게이션 설정
    private func showMainView() {
        let tabbarVC = TabBarController()
        tabbarVC.modalPresentationStyle = .fullScreen
        tabbarVC.modalTransitionStyle = .crossDissolve
        present(tabbarVC, animated: true)
    }
}
