//
//  UseDetailTableViewCell.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

import SnapKit
import Then

//MARK: - UseDetailTableViewCell
final class UseDetailTableViewCell: BaseTableViewCell {
    
    //MARK: - Components
    /// 반납 Image
    let returnImage = UIImageView()
    /// 이용내역 코멘트 Label
    let usingComment = UILabel()
    /// 대여장소 Label
    let rentLocationLabel = UILabel()
    /// 코멘트 + 대여장소 StackView
    let stackView = UIStackView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        returnImage.do {
            $0.image = UIImage()
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .black
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        usingComment.do {
            $0.textAlignment = .center
        }
        
        rentLocationLabel.do {
            $0.text = "대여장소: 서울특별시 강남구 강남대로 1234"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .trailing
        }
        
    }
    
    //MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(returnImage, stackView)
        stackView.addArrangedSubviews(usingComment, rentLocationLabel)
        
        returnImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(50)
            $0.height.equalTo(returnImage.snp.width)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configureCell(_ item: KickboardRide) {
        let address = item.address.components(separatedBy: " ")
        let minutes = Calendar.current.dateComponents([.minute], from: item.startTime, to: item.endTime ?? Date()).minute ?? 0
        
        let text = "포비와 \(address[1])에서 \(minutes)분 놀았어요!"
        let attributedText = NSMutableAttributedString.makeBoldAttributedString(
            fullText: text,
            boldParts: [address[1], String(minutes)],
            regularFont: .systemFont(ofSize: 15, weight: .regular),
            boldFont: .systemFont(ofSize: 15, weight: .bold),
            color: .black)
        
        if let imagePath = item.imagePath,
           let image = loadImageFromDirectory(with: imagePath) {
             returnImage.image = image
        }
        
        usingComment.attributedText = attributedText
        rentLocationLabel.text = "대여장소: \(item.address)"
        
    }
    
    func loadImageFromDirectory(with identifier: String) -> UIImage? {
        let fileManager = FileManager.default
        // 파일 경로로 접근
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(identifier, conformingTo: .jpeg)
        
        // 이미지 파일이 존재한다면, 이미지로 변환 후 리턴
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func testLoadImageFromDirectory() -> UIImage {
        // 1. 임의 이미지 생성
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 2. 파일 저장 (테스트 내부에서만)
        let fileManager = FileManager.default
        let identifier = "test_image"
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(identifier, conformingTo: .jpeg)
        if let data = testImage?.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
        // 3. 함수 테스트
        let loadedImage = loadImageFromDirectory(with: identifier)
        
        return loadedImage!
    }
    
}
