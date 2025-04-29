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
    
    /// 네이버 지도 View
    private let naverMapView = NMFNaverMapView(frame: .zero)
    /// 현재 위치 버튼
    private let locationButton = UIButton()
    
    /// 킥보드 숨기기 버튼
    private let hideKickboardButton = UIButton()
    
    private let vertialStackView = UIStackView()
    
    // MARK: - Style Helper
    
    override func setStyles() {
        naverMapView.do {
            $0.showScaleBar = false
            $0.showZoomControls = false
            $0.showIndoorLevelPicker = false
            $0.showLocationButton = false
            $0.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
            $0.mapView.zoomLevel = 15
            $0.mapView.minZoomLevel = 5.0
            $0.mapView.maxZoomLevel = 18.0
            $0.mapView.logoAlign = .rightTop
            $0.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.mapView.isTiltGestureEnabled = false
        }
        
        locationButton.do {
            $0.setImage(UIImage(named: "LocationButton.svg"), for: .normal)
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 4
        }
        
        hideKickboardButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            $0.setImage(UIImage(systemName: "eye.slash", withConfiguration: config), for: .normal)
            $0.tintColor = UIColor.core
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 4
        }
        
        vertialStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubviews(naverMapView, vertialStackView)
        vertialStackView.addArrangedSubviews(hideKickboardButton, locationButton)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        vertialStackView.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.width.equalTo(50)
        }
        
        locationButton.snp.makeConstraints {
//            $0.trailing.equalTo(self.safeAreaInsets).inset(15)
//            $0.bottom.equalTo(self.safeAreaInsets).inset(150)
            $0.width.height.equalTo(50)
        }
        
        hideKickboardButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vertialStackView.layoutIfNeeded()
        vertialStackView.subviews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
        }
    }
    
    // MARK: - Methods
    
    /// 네이버 지도 View 반환
    func getNaverMapView() -> NMFNaverMapView {
        return naverMapView
    }
    
    /// 현재 위치 버튼 반환
    func getLocationButton() -> UIButton {
        return locationButton
    }
    
    /// 킥보드 숨기기 버튼 반환
    func getHideKickboardButton() -> UIButton {
        return hideKickboardButton
    }
}
