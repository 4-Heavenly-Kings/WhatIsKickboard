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
    
    private let viewModel: ReturnViewModel
    
    private let contentView = ReturnView()
    private var customAlertView: CustomAlertView?
    
    private let returnUIModel: ReturnUIModel
    
    weak var refreshKickboardListDelegate: UpdateKickboardListDelegate?
    
    // MARK: - View Life Cycle
    /// 위도, 경도, 주소를 추가적으로 받아야함
    init(viewModel: ReturnViewModel , returnUIModel: ReturnUIModel) {
        self.viewModel = viewModel
        self.returnUIModel = returnUIModel
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
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
                guard let self else { return }
                self.viewModel.action.onNext(.returnKickboard(
                    latitude: self.returnUIModel.latitude,
                    longitude: self.returnUIModel.longitude,
                    battery: self.returnUIModel.battery,
                    imagePath: self.returnUIModel.imagePath,
                    address: self.returnUIModel.address
                ))
                self.showCustomAlert()
            }
            .disposed(by: disposeBag)
        
        viewModel.state.success
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                self?.showCustomAlert()
            }
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        view.backgroundColor = .white
        
        contentView.navigationBarView.configure(title: "반납하기", showsRightButton: false, rightButtonTitle: nil)
        contentView.feeLabelView.configure(extraFee: "\(returnUIModel.price - 500 >= 0 ? returnUIModel.price - 500 : 0 )")
        contentView.returnStackView.configure(time: returnUIModel.returnMinutes, battery: returnUIModel.battery, fee: "\(returnUIModel.price)")
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
                self?.refreshKickboardListDelegate?.updateKickboardList()
                self?.customAlertView = nil
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func setImage() {
        if let image = UIImage(contentsOfFile: returnUIModel.imagePath) {
            contentView.imageView.image = image
        } else {
            print("이미지 로딩 실패")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
