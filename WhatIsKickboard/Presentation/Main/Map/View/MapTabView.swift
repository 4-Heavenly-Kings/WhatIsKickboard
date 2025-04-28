//
//  MapTabView.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import UIKit

import NMapsMap
import SnapKit
import Then

final class MapTabView: BaseView {
    
    // MARK: - UI Components
    
    private let naverMapView = NMFNaverMapView(frame: .zero)
    
    private let locationButton = UIButton()
    
    // MARK: - Style Helper
    
    override func setStyles() {
        naverMapView.do {
            $0.showLocationButton = false
            $0.showScaleBar = false
            $0.showZoomControls = false
            $0.showIndoorLevelPicker = false
            $0.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
            $0.mapView.zoomLevel = 16
            $0.mapView.minZoomLevel = 5.0
            $0.mapView.maxZoomLevel = 18.0
            $0.mapView.isTiltGestureEnabled = false
            $0.mapView.logoAlign = .leftTop
        }
        
        locationButton.do {
            $0.setImage(UIImage(named: "UserLocation.svg"), for: .normal)
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubviews(naverMapView, locationButton)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaInsets).inset(15)
            $0.bottom.equalTo(self.safeAreaInsets).inset(150)
            $0.width.height.equalTo(50)
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        locationButton.layer.cornerRadius = locationButton.frame.width / 2
    }
    
    // MARK: - Methods
    
    func getNaverMapView() -> NMFNaverMapView {
        return naverMapView
    }
    
    func getLocationButton() -> UIButton {
        return locationButton
    }
}
