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

/// 지도 탭 View
final class MapTabView: BaseView {
    
    // MARK: - UI Components
    
    /// 네이버 지도 NMFNaverMapView
    private lazy var naverMapView = NMFNaverMapView(frame: .zero).then {
        $0.showCompass = false
        $0.showScaleBar = false
        $0.showZoomControls = false
        $0.showIndoorLevelPicker = false
        $0.showLocationButton = false
        
        $0.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
        $0.mapView.zoomLevel = 15
        $0.mapView.minZoomLevel = 5
        $0.mapView.maxZoomLevel = 18
        $0.mapView.logoAlign = .leftBottom
        $0.mapView.logoMargin = UIEdgeInsets(top: 0, left: 15, bottom: 40, right: 0)
        $0.mapView.isTiltGestureEnabled = false
    }
    /// 네이버 지도 나침반 버튼 NMFCompassView
    private let compassButton = NMFCompassView()
    /// 지도 관련 버튼을 담고있는 수직 UIStackView
    private let buttonStackView = UIStackView()
    /// 킥보드 숨기기 버튼 UIButton
    private let hideKickboardButton = UIButton()
    /// 현재 위치 버튼 UIButton
    private let locationButton = UIButton()
    /// 네비게이션 바 흰색 UIView
    private let statusBarBackgroundView = UIView()
    /// 네비게이션 바(킥보드 위치 등록 모드 전용) CustomNavigationBarView
    private let navigationBarView = CustomNavigationBarView()
    /// 장소 검색창 UISearchBar
    private let searchBar = UISearchBar()
    /// resultTableView 높이 조절 및 그림자 효과 UIView
    private let tableViewContainer = UIView()
    /// 장소 검색 결과 UITableView
    private let resultTableView = UITableView()
    /// 킥보드 등록 위치 표시 마커
    private let centerMarkerImageView = UIImageView()
    
    // MARK: - Style Helper
    
    override func setStyles() {
        compassButton.do {
            $0.mapView = naverMapView.mapView
        }
        
        buttonStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
        }
        
        hideKickboardButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            $0.setImage(UIImage(systemName: "eye.slash", withConfiguration: config), for: .normal)
            $0.tintColor = UIColor.core
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 2
        }
        
        locationButton.do {
            $0.setImage(UIImage(named: "LocationButton.svg"), for: .normal)
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 2
        }
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.isHidden = true
        }
        
        navigationBarView.do {
            $0.configure(title: "킥보드 위치 등록", showsRightButton: true, rightButtonTitle: "등록")
            $0.isHidden = true
        }
        
        searchBar.do {
            $0.searchBarStyle = .minimal
            $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
            $0.placeholder = "장소를 입력해주세요"
            $0.searchTextField.font = .systemFont(ofSize: 16)
            $0.searchTextField.textColor = UIColor(hex: "#000000")
            
            let spacer = UIView()
            spacer.frame.size.width = 8
            $0.searchTextField.leftView = spacer
            // TODO: 오른쪽 패딩
            $0.searchTextField.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.searchTextField.borderStyle = .none
            $0.searchTextField.layer.borderWidth = 4
            $0.searchTextField.layer.borderColor = UIColor.core.cgColor
            
            $0.searchTextField.layer.shadowColor = UIColor.gray.cgColor
            $0.searchTextField.layer.shadowOpacity = 1.0
            $0.searchTextField.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            $0.searchTextField.layer.shadowRadius = 2
        }
        
        tableViewContainer.do {
            $0.backgroundColor = .clear
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            $0.layer.shadowRadius = 2
        }
        
        resultTableView.do {
            $0.rowHeight = 40
            $0.isScrollEnabled = false
        }
        
        centerMarkerImageView.do {
            $0.image = .centerMarker
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .clear
            $0.isHidden = true
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubviews(naverMapView, compassButton, buttonStackView,
                         statusBarBackgroundView, navigationBarView,
                         searchBar, tableViewContainer,
                         centerMarkerImageView)
        buttonStackView.addArrangedSubviews(hideKickboardButton, locationButton)
        tableViewContainer.addSubview(resultTableView)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        compassButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.width.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            $0.width.equalTo(50)
        }
        
        hideKickboardButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        locationButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
        }
        
        tableViewContainer.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(0)
        }
        
        resultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerMarkerImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.safeAreaLayoutGuide)
            $0.centerY.equalTo(self.safeAreaLayoutGuide).offset(-8)
            $0.width.height.equalTo(50)
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 코너값, 그림자 설정
        buttonStackView.layoutIfNeeded()
        buttonStackView.subviews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
            let bezierCGPath = UIBezierPath(roundedRect: $0.bounds, cornerRadius: $0.layer.cornerRadius).cgPath
            $0.layer.shadowPath = bezierCGPath
        }
        
        searchBar.layoutIfNeeded()
        let searchTextField = searchBar.searchTextField
        searchTextField.layer.cornerRadius = searchTextField.frame.height / 2
        let searchBarCGPath = UIBezierPath(roundedRect: searchTextField.bounds,
                                        cornerRadius: searchTextField.layer.cornerRadius).cgPath
        searchTextField.layer.shadowPath = searchBarCGPath
        
        tableViewContainer.layoutIfNeeded()
        tableViewContainer.layer.cornerRadius = 10
        let containerCGPath = UIBezierPath(roundedRect: tableViewContainer.bounds,
                                        cornerRadius: tableViewContainer.layer.cornerRadius).cgPath
        tableViewContainer.layer.shadowPath = containerCGPath
        
        resultTableView.layoutIfNeeded()
        resultTableView.layer.cornerRadius = 10
    }
    
    // MARK: - Methods
    
    /// naverMapView 반환
    func getNaverMapView() -> NMFNaverMapView {
        return naverMapView
    }
    
    /// hideKickboardButton 반환
    func getHideKickboardButton() -> UIButton {
        return hideKickboardButton
    }
    
    /// locationButton 반환
    func getLocationButton() -> UIButton {
        return locationButton
    }
    
    /// 네비게이션 바 배경 반환
    func getStatusBarBackgroundView() -> UIView {
        return statusBarBackgroundView
    }
    
    /// navigationBarView 반환
    func getNavigationBarView() -> CustomNavigationBarView {
        return navigationBarView
    }
    
    /// searchBar 반환
    func getSearchBar() -> UISearchBar {
        return searchBar
    }
    
    /// resultTableView 반환
    func getSearchResultTableView() -> UITableView {
        return resultTableView
    }
    
    func getCenterMarkerImageView() -> UIImageView {
        return centerMarkerImageView
    }
    
    /// resultTableView(tableViewContainer) 높이 및 그림자 효과 업데이트
    func updateTableViewAppearance(heightTo height: ConstraintRelatableTarget) {
        tableViewContainer.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        tableViewContainer.layoutIfNeeded()
        tableViewContainer.layer.shadowColor = UIColor.gray.cgColor
        tableViewContainer.layer.shadowOpacity = 1.0
        tableViewContainer.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        tableViewContainer.layer.shadowRadius = 2
        
        let bezierCGPath = UIBezierPath(roundedRect: tableViewContainer.bounds,
                                        cornerRadius: tableViewContainer.layer.cornerRadius).cgPath
        tableViewContainer.layer.shadowPath = bezierCGPath
    }
    
    /// resultTableView(tableViewContainer).isHidden 상태 설정
    func updateTableViewHideState(to state: Bool) {
        tableViewContainer.isHidden = state
        resultTableView.isHidden = state
    }
}
