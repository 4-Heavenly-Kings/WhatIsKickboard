//
//  ModifyViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - View Life Cycle
final class ModifyViewController: BaseViewController {
        
    // MARK: - UI Components
    private let modifyView = ModifyView()
    
    // MARK: - Properties
    private var modityType: ModifyType
    
    init(modityType: ModifyType) {
        self.modityType = modityType
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = modifyView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func bindViewModel() {
        modifyView.navigationBarView.getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
                print("did Tap back Button")
            }
            .disposed(by: disposeBag)
        
        modifyView.navigationBarView.getRightButton().rx.tap
            .bind(with: self) { owner, _ in
                print("저장버튼")
            }
            .disposed(by: disposeBag)
        
    }

    override func setStyles() {
        modifyView.navigationBarView.configure(title: modityType.navigationTitle, showsRightButton: true, rightButtonTitle: "저장")
        modifyView.modifyStackView.configure(modityType)
    }
    
    override func setLayout() {

    }
}

