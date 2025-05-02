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
            $0.contentMode = .scaleAspectFill
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
        
        if let imagePath = item.imagePath, let image = UIImage(contentsOfFile: imagePath) {
            returnImage.image = image
        } else {
            print("이미지 로딩 실패")
        }
        
        usingComment.attributedText = attributedText
        rentLocationLabel.text = "대여장소: \(item.address)"
    }
}
