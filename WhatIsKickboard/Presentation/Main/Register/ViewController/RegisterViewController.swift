//
//  RegisterViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class RegisterViewController: BaseViewController {
        
    private let viewModel: RegisterViewModel

    private let contentView = RegisterView()
    private var customAlertView: CustomAlertView?

    private let registerUIModel: RegisterUIModel
    
    // MARK: - View Life Cycle

    init(viewModel: RegisterViewModel, registerUIModel: RegisterUIModel) {
        self.viewModel = viewModel
        self.registerUIModel = registerUIModel
        super.init(nibName: nil, bundle: nil)
    }
    
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
                print("did Tap back Button")
            }
            .disposed(by: disposeBag)
        
        contentView.navigationBarView.getRightButton().rx.tap
            .bind { [weak self] in
                guard let self else { return }
                let text = self.contentView.registerStackView.getBatteryTextField().text ?? ""

                if let value = Int(text), (0...100).contains(value) {
                    let model = RegisterUIModel(
                        latitude: registerUIModel.latitude,
                        longitude: registerUIModel.longitude,
                        address: registerUIModel.address
                    )
                    viewModel.action.onNext(.createKickboard(model, value))
                } else {
                    showAlert(type: .batteryInputFailed)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.state.success
            .observe(on: MainScheduler.instance)
            .bind { [weak self] uuid in
                print("킥보드 저장 성공! ID: \(uuid)")
                self?.showAlert(type: .successCreateKickboard) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind { [weak self] error in
                print("저장 실패: \(error.localizedDescription)")
                self?.showAlert(type: .failCreateKickboard)

            }
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        contentView.navigationBarView.configure(title: "킥보드 정보 설정", showsRightButton: true, rightButtonTitle: "저장")
        contentView.registerStackView.configure(location: "서울 구로구")
    }
    
    private func showAlert(type: CustomAlertViewType, onDismiss: (() -> Void)? = nil) {
        let alert = CustomAlertView(frame: .zero, alertType: type)
        view.addSubview(alert)
        alert.snp.makeConstraints { $0.edges.equalToSuperview() }

        alert.configure(name: "")

        alert.getSubmitButton().rx.tap
            .bind { [weak self, weak alert] in
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                onDismiss?()
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
