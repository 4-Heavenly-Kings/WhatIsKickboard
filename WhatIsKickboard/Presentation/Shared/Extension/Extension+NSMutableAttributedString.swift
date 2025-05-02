//
//  Extension+NSMutableAttributedString.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

extension NSMutableAttributedString {
    
    // MARK: - Methods
    /// 원하는 단어 부분만 color와 font를 지정해줄 수 있는 메서드
    /// 사용방법
    /*
     let attributedText = NSMutableAttributedString.makeAttributedString(
         text: text,
         highlightedParts: [
             ("15분", .black, UIFont.systemFont(ofSize: 30, weight: .bold)),
             ("이용 중", .black, UIFont.systemFont(ofSize: 30, weight: .regular))
         ]
     )
     지정해주고자 하는 내용과 텍스트 컬러, 폰트를 지정해주면 됩니다.
     */
    static func makeAttributedString(text: String, highlightedParts: [(substring: String, color: UIColor, font: UIFont)]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        highlightedParts.forEach { part in
            let range = (text as NSString).range(of: part.substring)
            attributedString.addAttribute(.foregroundColor, value: part.color, range: range)
            attributedString.addAttribute(.font, value: part.font, range: range)
        }
        return attributedString
    }
    
    /// 문장에서 특정 부분만 bold 처리해주는 메서드
    /// font와 textColor는 동일하지만 weight를 다르게 지정해줄 수 있음
    /// 사용방법
    /*
     let attributedText = NSAttributedString.makeBoldAttributedString(
         fullText: "강남구에서 15분 이용 중",
         boldParts: ["강남구", "15분"],
         regularFont: .systemFont(ofSize: 15),
         boldFont: .boldSystemFont(ofSize: 15),
         color: .black
     )
     */
    static func makeBoldAttributedString(fullText: String, boldParts: [String], regularFont: UIFont, boldFont: UIFont, color: UIColor
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .font: regularFont,
            .foregroundColor: color
        ])
        
        for boldText in boldParts {
            let range = (fullText as NSString).range(of: boldText)
            if range.location != NSNotFound {
                attributedString.addAttributes([
                    .font: boldFont,
                    .foregroundColor: color
                ], range: range)
            }
        }
        
        return attributedString
    }
}

    
