//
//  MapTabView.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import UIKit

import NMapsMap
import RxSwift
import RxRelay
import SnapKit
import Then

/// 지도 탭 View
final class MapTabView: BaseView {
    
    // MARK: - Properties
    
    /// MapTabView 현재 모드
    let currentModeRelay = BehaviorRelay<MapTabViewMode>(value: .map)
    
    private let disposeBag = DisposeBag()
    
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
    /// 네이버 지도 나침반 NMFCompassView
    private let compassButton = NMFCompassView()
    /// 지도 관련 버튼을 담고있는 수직 UIStackView
    private let buttonStackView = UIStackView()
    /// 킥보드 숨기기 UIButton
    private let hideKickboardButton = UIButton()
    /// 현재 위치 UIButton
    private let locationButton = UIButton()
    /// 킥보드 신고 UIButton
    private let declareButton = UIButton()
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
    /// 대여/반납 모달 컨테이너 UIView
    private let modalLikeContainerView = UIView()
    /// 대여/반납 모달 UIView
    private let mapUsingKickboardView = MapUsingKickboardView()
    /// 대여하기/반납하기 CustomSubmitButton
    private let rentOrReturnButton = CustomSubmitButton()
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        // MapTabView 현재 모드 설정
        currentModeRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, mode in
                switch mode {
                case .map:
                    owner.searchBar.isHidden = false
                    owner.searchBar.text = ""
                    owner.searchBar.snp.remakeConstraints {
                        $0.top.equalTo(self.safeAreaLayoutGuide).inset(10)
                        $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
                    }
                    owner.hideKickboardButton.isHidden = false
                    owner.declareButton.isHidden = true
                    owner.buttonStackView.snp.remakeConstraints {
                        $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
                        $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
                        $0.width.equalTo(50)
                    }
                    owner.statusBarBackgroundView.isHidden = true
                    owner.navigationBarView.isHidden = true
                    owner.centerMarkerImageView.isHidden = true
                    owner.showModalDownAnimation()
                case .registerKickboard:
                    owner.searchBar.text = ""
                    owner.searchBar.snp.remakeConstraints {
                        $0.top.equalTo(owner.navigationBarView.snp.bottom).offset(10)
                        $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
                    }
                    owner.statusBarBackgroundView.isHidden = false
                    owner.navigationBarView.isHidden = false
                    owner.centerMarkerImageView.isHidden = false
                case .touchKickboard:
                    owner.searchBar.isHidden = false
                    owner.searchBar.text = ""
                    owner.declareButton.isHidden = false
                    owner.hideKickboardButton.isHidden = true
                    owner.buttonStackView.snp.remakeConstraints {
                        $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
                        $0.bottom.equalTo(owner.modalLikeContainerView.snp.top)
                        $0.width.equalTo(50)
                    }
                    owner.showModalUpAnimation()
                    owner.rentOrReturnButton.configure(buttonTitle: "대여하기")
                case .usingKickboard:
                    owner.declareButton.isHidden = true
                    owner.updateUsingTimeLabel(elapsedSeconds: 0)
                    owner.rentOrReturnButton.configure(buttonTitle: "반납하기")
                case .returnKickboard:
                    owner.showModalDownAnimation()
                    owner.currentModeRelay.accept(.map)
                }
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        declareButton.do {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
            $0.setImage(UIImage(systemName: "light.beacon.max.fill", withConfiguration: config), for: .normal)
            $0.tintColor = UIColor(hex: "#FBC49C")
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 2
        }
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
        navigationBarView.do {
            $0.configure(title: "킥보드 위치 등록", showsRightButton: true, rightButtonTitle: "등록")
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
        }
        
        modalLikeContainerView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hex: "#E7E7E7").cgColor
        }
        
        rentOrReturnButton.configure(buttonTitle: "대여하기")
        
        setModalLikeTransform()
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.addSubviews(naverMapView, compassButton, buttonStackView, declareButton,
                         statusBarBackgroundView, navigationBarView,
                         searchBar, tableViewContainer,
                         centerMarkerImageView, modalLikeContainerView)
        buttonStackView.addArrangedSubviews(hideKickboardButton, locationButton)
        tableViewContainer.addSubview(resultTableView)
        modalLikeContainerView.addSubviews(mapUsingKickboardView, rentOrReturnButton)
        
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
        
        declareButton.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(15)
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
        
        modalLikeContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(290)
        }
        
        mapUsingKickboardView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(rentOrReturnButton.snp.top).offset(-16)
        }
        
        rentOrReturnButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Lifecycle
    
    // cornerRadius, 그림자 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonStackView.layoutIfNeeded()
        buttonStackView.subviews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
            let bezierCGPath = UIBezierPath(roundedRect: $0.bounds, cornerRadius: $0.layer.cornerRadius).cgPath
            $0.layer.shadowPath = bezierCGPath
        }
        
        declareButton.layoutIfNeeded()
        declareButton.layer.cornerRadius = declareButton.frame.width / 2
        let reportButtonCGPath = UIBezierPath(roundedRect: declareButton.bounds, cornerRadius: declareButton.layer.cornerRadius).cgPath
        declareButton.layer.shadowPath = reportButtonCGPath
        
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
}

// MARK: - Get Components Methods

extension MapTabView {
    /// naverMapView 반환
    func getNaverMapView() -> NMFNaverMapView {
        return naverMapView
    }
    
    /// hideKickboardButton 반환
    func getHideKickboardButton() -> UIButton {
        return hideKickboardButton
    }
    
    /// reportButton 반환
    func getDeclareButton() -> UIButton {
        return declareButton
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
    
    /// centerMarkerImageView 반환
    func getCenterMarkerImageView() -> UIImageView {
        return centerMarkerImageView
    }
    
    /// modalLikeContainerView 반환
    func getModalLikeContainerView() -> UIView {
        return modalLikeContainerView
    }
    
    /// mapUsingKickboardView 반환
    func getMapUsingKickboardView() -> MapUsingKickboardView {
        return mapUsingKickboardView
    }
    
    /// rentOrReturnButton 반환
    func getRentOrReturnButton() -> CustomSubmitButton {
        return rentOrReturnButton
    }
}

// MARK: - UI Appearance Methods

extension MapTabView {
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
    
    /// 킥보드 대여/반납 모달 애니메이션 세팅
    func setModalLikeTransform() {
        modalLikeContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
    }
    
    /// 킥보드 대여/반납 모달 올림 애니메이션
    func showModalUpAnimation() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.modalLikeContainerView.transform = CGAffineTransform(translationX: 0, y: 20)
        }
    }
    
    /// 킥보드 대여/반납 모달 내림 애니메이션
    func showModalDownAnimation() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.modalLikeContainerView.transform = CGAffineTransform(translationX: 0, y: 400)
        }
    }
    
    /// 이용 시간 UI 업데이트
    func updateUsingTimeLabel(elapsedSeconds: Int) {
        let usingTimeText = elapsedSeconds < 60 ? "\(elapsedSeconds)초" : "\(elapsedSeconds / 60)분"
        let suffixText = " 이용 중"
        let attributedText = NSMutableAttributedString.makeAttributedString(
            text: usingTimeText + suffixText,
            highlightedParts: [
                (usingTimeText, .black, UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold))
            ]
        )
        mapUsingKickboardView.usingTimeLabel.attributedText = attributedText
        mapUsingKickboardView.usingTimeLabel.textAlignment = .center
        mapUsingKickboardView.usingTimeLabel.textColor = .black
    }
}
