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
    
    private let contentView = ReturnView()
    private var customAlertView: CustomAlertView?
    
    private let imagePath: String

    
    // MARK: - View Life Cycle
    
    init(imagePath: String) {
        self.imagePath = imagePath
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
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
                /// 이게 이미지 경로라 이거를 CoreData로 주면 될 것 같아요~
                if let imagePath = self?.imagePath {
                    print("🖼️ 이미지 경로:", imagePath)
                }
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func setImage() {
        if let image = UIImage(contentsOfFile: imagePath) {
            contentView.imageView.image = image
        } else {
            print("❌ 이미지 로딩 실패")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
