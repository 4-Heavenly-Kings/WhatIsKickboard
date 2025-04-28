//
//  CustomAlertView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit

class CustomAlertView: BaseView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let submitButton = UIButton()
    private let cancelButton = UIButton()
    
    private let alertType: CustomAlertViewType
    
    enum CustomAlertViewType {
        case returnRequest
        case myPage
    }
    
    init(frame: CGRect, alertType: CustomAlertViewType) {
        self.alertType = alertType
        super.init(frame: frame)
    }
    
    override func setStyles() {
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {}
    
    // MARK: - Methods
    /// 받는 데이터의 형식에 따라 수정됩니다.
    func configure(_ price: String) {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
