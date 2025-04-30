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
    private let modifyViewModel = ModifyViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func bindUIEvents() {
        modifyView.navigationBarView.getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
                print("did Tap back Button")
            }
            .disposed(by: disposeBag)
        
        modifyView.navigationBarView.getRightButton().rx.tap
            .bind(with: self) { owner, _ in
                print("저장버튼")
                switch owner.modityType {
                case .name:
                    let nameText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.name(nameText))
                case .password:
                    let passwordText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    let passwordCheckText = owner.modifyView.modifyStackView.modifyCheckTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.password(passwordText, passwordCheckText))
                case .withdrawal:
                    let passwordText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    let passwordCheckText = owner.modifyView.modifyStackView.modifyCheckTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.password(passwordText, passwordCheckText))
                    owner.modifyViewModel.action.onNext(.withdrawal(passwordText, passwordCheckText))
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        
    }

    override func setStyles() {
        modifyView.navigationBarView.configure(title: modityType.navigationTitle, showsRightButton: true, rightButtonTitle: modityType.rightBarButtonTitle)
        modifyView.modifyStackView.configure(modityType)
    }
    
    override func setLayout() {

    }
}
