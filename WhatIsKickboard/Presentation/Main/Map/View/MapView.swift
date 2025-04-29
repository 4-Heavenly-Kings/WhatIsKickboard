//
//  MapView.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import UIKit

import NMapsMap
import SnapKit
import Then

final class MapView: BaseView {
    
    // MARK: - UI Components
    
    private let naverMapView = NMFNaverMapView(frame: .zero)
    
    // MARK: - Style Helper
    
    override func setStyles() {
        naverMapView.do {
            $0.showLocationButton = true
            $0.mapView.zoomLevel = 16
            $0.mapView.positionMode = .direction
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
