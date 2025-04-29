//
//  MyPageViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyPageViewController: BaseViewController {
    
    let myPageView = MyPageView()
    
    override func loadView() {
        super.loadView()
        
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
    }
    
    override func setStyles() {
        super.setStyles()
        
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
    
}
