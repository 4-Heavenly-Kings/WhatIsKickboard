//
//  ReturnViewController.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ReturnViewController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    
    private let contentView = ReturnView()
    private var customAlertView: CustomAlertView?

    
    // MARK: - View Life Cycle

    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindViewModel() {
        contentView.navigationBarView.getBackButton().rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        contentView.customSubmitButton.rx.tap
            .bind { [weak self] in
                self?.showCustomAlert()
            }
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        view.backgroundColor = .white
        
        contentView.navigationBarView.configure(title: "반납하기", showsRightButton: false, rightButtonTitle: nil)
        contentView.feeLabelView.configure(extraFee: "2,200")
        contentView.returnStackView.configure(time: 22, battery: 55, fee: "2,700")
        contentView.customSubmitButton.configure(buttonTitle: "반납하기")
    }
    
    override func setLayout() {

    }
    
    private func showCustomAlert() {
        let alert = CustomAlertView(frame: .zero, alertType: .confirmReturn)
        
        view.addSubview(alert)
        
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert.configure(
            name: "천성우",
            minutes: nil,
            count: nil,
            price: nil
        )
        
        alert.getSubmitButton().rx.tap
            .bind { [weak self, weak alert] in
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    
}
