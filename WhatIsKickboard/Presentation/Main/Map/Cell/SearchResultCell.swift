//
//  SearchResultCell.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class SearchResultCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    private var location: LocationModel?
    
    // MARK: - UI Components
    
    private let locationLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyles() {
        locationLabel.do {
            $0.font = .systemFont(ofSize: 15)
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func configure(location: LocationModel) {
        self.location = location
        locationLabel.text = location.title
    }
}
