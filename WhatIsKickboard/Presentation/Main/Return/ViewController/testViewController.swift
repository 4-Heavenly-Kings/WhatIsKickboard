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
import UniformTypeIdentifiers

final class testViewController: BaseViewController {
    
    private let viewModel: TestViewModel
    
    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let showAlertButton = UIButton()
    private var customAlertView: CustomAlertView?
    
    private var returnPrice: Int = 0
    private var returnBattery: Int = 0
    private var returnMinutes: Int = 0

    override func bindViewModel() {
        
        // 1. 버튼 탭 → UseCase 실행 트리거
        showAlertButton.rx.tap
            .map { TestViewModel.Action.requestReturn }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        // 2. 킥보드 + 유저 정보 수신 → Alert 구성
        Observable
            .combineLatest(viewModel.state.kickboardRide, viewModel.state.user)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] kickboard, user in
                self?.showCustomAlert(user: user, kickboard: kickboard)
            }
            .disposed(by: disposeBag)
        
        // 3. 에러 핸들링
        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind { error in
                print("오류 발생: \(error.localizedDescription)")
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
    
    private func showCustomAlert(user: User, kickboard: KickboardRide) {
        let name = user.name ?? "이름 없음"
        self.returnMinutes = calculateElapsedMinutes(kickboard: kickboard, userId: user.id)
        self.returnPrice = (returnMinutes * 100) + 500
        self.returnBattery = kickboard.battery
        
        
        print(returnPrice)

        let alert = CustomAlertView(frame: .zero, alertType: .returnRequest)
        view.addSubview(alert)
        alert.snp.makeConstraints { $0.edges.equalToSuperview() }

        alert.configure(
            name: name,
            minutes: returnMinutes,
            count: nil,
            price: "\(returnPrice)"
        )

        alert.getSubmitButton().rx.tap
            .bind { [weak self, weak alert] in
                print("getSubmitButton")
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                self?.openCamera()
            }
            .disposed(by: disposeBag)

        alert.getCancelButton().rx.tap
            .bind { [weak self, weak alert] in
                print("getCancelButton")
                alert?.removeFromSuperview()
                self?.customAlertView = nil
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func calculateElapsedMinutes(kickboard: KickboardRide, userId: UUID) -> Int {
        let startTime = kickboard.startTime
        let now = Date()
        let minutes = Calendar.current.dateComponents([.minute], from: startTime, to: now).minute ?? 0
        return minutes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension testViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("카메라 사용 불가")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = [UTType.image.identifier]
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                if let imagePath = self.saveImageToDocuments(image: image) {
                    let repository = ReturnKickboardRepository()
                    let useCase = ReturnKickboardUseCaseInterface(repository: repository)
                    let viewModel = ReturnViewModel(returnKickboardUseCase: useCase)
                    let returnUIModel = ReturnUIModel(
                        imagePath: imagePath,
                        price: self.returnPrice,
                        battery: self.returnBattery,
                        returnMinutes: self.returnMinutes,
                        /// 하기의 값에 위도, 경도, 주소를 순서로 넣으면 됩니다.
                        latitude: 37.1234,
                        longitude: 127.5678,
                        address: "서울특별시 종로구 세종대로 175"
                    )
                    let returnVC = ReturnViewController(viewModel: viewModel, returnUIModel: returnUIModel)
                    self.navigationController?.pushViewController(returnVC, animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let filename = UUID().uuidString + ".jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("이미지 저장 실패: \(error)")
            return nil
        }
    }
}
