//
//  testViewController.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class testViewController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    
    private let showAlertButton = UIButton()
    private var customAlertView: CustomAlertView?

    override func bindViewModel() {
        showAlertButton.rx.tap
            .bind { [weak self] in
                self?.showCustomAlert()
            }
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        view.backgroundColor = .white
        
        showAlertButton.do {
            $0.setTitle("반납하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .systemBlue
            $0.layer.cornerRadius = 10
        }
    }
    
    override func setLayout() {
        view.addSubview(showAlertButton)
        
        showAlertButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    private func showCustomAlert() {
        let alert = CustomAlertView(frame: .zero, alertType: .returnRequest)
        
        view.addSubview(alert)
        
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert.configure(
            name: "천성우",
            minutes: 22,
            count: nil,
            price: "5,000"
        )
        
        alert.getSubmitButton().rx.tap
            .bind { [weak self, weak alert] in
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                print("포비와 그만 놀기 버튼 눌림")
                let vc = ReturnViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        alert.getCancelButton().rx.tap
            .bind { [weak self, weak alert] in
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                print("더 달리기 버튼 눌림")
            }
            .disposed(by: disposeBag)
        
        self.customAlertView = alert
    }
    
}
