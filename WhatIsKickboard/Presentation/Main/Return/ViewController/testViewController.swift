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
                self?.openCamera()
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
                    let returnVC = ReturnViewController(imagePath: imagePath)
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
