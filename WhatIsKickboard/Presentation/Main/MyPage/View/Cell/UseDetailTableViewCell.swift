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
    /// 포비 킥보드 Image
    let pobyImageView = UIImageView()
    /// 반납 Image
    let returnImage = UIImageView()
    /// 이용내역 코멘트 Label
    let usingComment = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        pobyImageView.do {
            $0.image = UIImage(named: "PobyRiding")
            $0.contentMode = .scaleAspectFit
        }
        
        returnImage.do {
            $0.image = UIImage()
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .black
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        usingComment.do {
            let text = "포비와 강남구에서 15분 놀았어요!"
            let attributedText = NSMutableAttributedString.makeBoldAttributedString(
                fullText: text,
                boldParts: ["강남구", "15분"],
                regularFont: .systemFont(ofSize: 15, weight: .regular),
                boldFont: .systemFont(ofSize: 15, weight: .bold),
                color: .black)
            $0.attributedText = attributedText
            $0.textAlignment = .center
        }
        
    }
    
    //MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(pobyImageView, returnImage, usingComment)
        
        pobyImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.width.equalTo(40)
            $0.height.equalTo(pobyImageView.snp.width).multipliedBy(1.5)
        }
        
        returnImage.snp.makeConstraints {
            $0.verticalEdges.equalTo(pobyImageView)
            $0.leading.equalTo(pobyImageView.snp.trailing).offset(8)
            $0.height.equalTo(pobyImageView)
            $0.width.equalTo(returnImage.snp.height)
        }
        
        usingComment.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
}
