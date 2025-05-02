//
//  MapTabViewController.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import UIKit
import CoreLocation

import NMapsMap
import RxCocoa
import RxSwift
import SnapKit
import Then

/// 지도 탭 ViewController
final class MapTabViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = MapTabViewModel()

    /// 지도 애니메이션 상태 관리용
    private var mapPositionMode: NMFMyPositionMode = .disabled
    /// 킥보드 마커 리스트
    private var kickboardMarkerList = [NMFMarker]()
    /// 킥보드 마커 숨김 상태
    private var isAllMarkerHidden: Bool = false {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let buttonImage = UIImage(systemName: isAllMarkerHidden ? "eye" : "eye.slash", withConfiguration: config)
            mapTabView.getHideKickboardButton().setImage(buttonImage, for: .normal)
        }
    }
    /// 킥보드 등록 모드
    var isRegister: Bool = false {
        didSet {
            self.tabBarController?.tabBar.isHidden = isRegister
            mapTabView.getStatusBarBackgroundView().isHidden = !isRegister
            mapTabView.getNavigationBarView().isHidden = !isRegister
            mapTabView.getCenterMarkerImageView().isHidden = !isRegister
            mapTabView.getSearchBar().text = ""
            mapTabView.getSearchBar().snp.remakeConstraints {
                if isRegister {
                    $0.top.equalTo(mapTabView.getNavigationBarView().snp.bottom).offset(10)
                    $0.leading.trailing.equalTo(mapTabView.safeAreaLayoutGuide).inset(15)
                } else {
                    $0.top.equalTo(mapTabView.safeAreaLayoutGuide).inset(10)
                    $0.leading.trailing.equalTo(mapTabView.safeAreaLayoutGuide).inset(15)
                }
            }
        }
    }
    
    /// 지도 카메라 좌표
    private var cameraCoordinates = NMGLatLng()
    /// 검색창 주소
    private var address = ""
    
    /// TabBarController 관련 Delegate
    weak var changeSelectedIndexDelegate: ChangeSelectedIndexDelegate?
    
    // MARK: - UI Components
    
    /// 지도 탭 View
    private let mapTabView = MapTabView()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        // ViewModel ➡️ State
        // 사용자 위치로 카메라 이동
        viewModel.state.userLocation
            .compactMap { $0 }
            .bind(with: self) { owner, coordinates in
                let mapView = owner.mapTabView.getNaverMapView().mapView
                if mapView.positionMode == .disabled {
                    mapView.positionMode = .normal
                    owner.mapPositionMode = .direction
                }
                
                if owner.mapPositionMode == .direction {
                    owner.moveMapCamera(to: coordinates)
                }
            }.disposed(by: disposeBag)
        
        // 킥보드 마커 생성
        viewModel.state.kickboardList
            .withUnretained(self)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { owner, kickboardList in
                owner.makeMarkerList(of: kickboardList)
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, markerList in
                // 마커 맵에서 삭제
                owner.kickboardMarkerList.forEach {
                    $0.mapView = nil
                }
                
                // 변경된 마커 업데이트
                owner.kickboardMarkerList.removeAll()
                markerList.forEach {
                    owner.kickboardMarkerList.append($0)
                }
                
                // 지도에 표시
                owner.kickboardMarkerList.forEach {
                    if $0.mapView == nil {
                        $0.mapView = owner.mapTabView.getNaverMapView().mapView
                    }
                }
            }.disposed(by: disposeBag)
        
        // 장소 검색 결과 표시
        viewModel.state.locationSearchResult
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] locationList in
                guard let self else { return }
                
                let totalHeight = locationList.count * 40
                self.mapTabView.updateTableViewAppearance(heightTo: totalHeight)
            })
            .drive(mapTabView.getSearchResultTableView().rx.items(
                cellIdentifier: SearchResultCell.className,
                cellType: SearchResultCell.self)) { _, location, cell in
                    cell.configure(location: location)
            }.disposed(by: disposeBag)
        
        // 좌표 검색 결과 표시
        viewModel.state.reverseGeoSearchResult
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, location in
                guard let nearest = location.first else { return }
                owner.address = owner.makeAddress(location: nearest)
                owner.mapTabView.getSearchBar().text = owner.address
            }.disposed(by: disposeBag)
        
        
        // TODO: 반납) 킥보드 UUID
        
        // Action ➡️ ViewModel
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didLocationButtonTap)
            }.disposed(by: disposeBag)
        
        // 장소 검색창 텍스트 전달
        mapTabView.getSearchBar().rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.viewModel.action.onNext(.searchText(text: text))
            }.disposed(by: disposeBag)
        
        // 바인딩 완료 알림
        viewModel.action.onNext(.didBinding)
        
        
        // View ➡️ ViewController
        
        // 검색 결과 탭
        mapTabView.getSearchResultTableView().rx
            .modelSelected(LocationModel.self)
            .bind(with: self) { owner, location in
                // 지도 카메라 이동
                owner.mapPositionMode = .normal
                owner.mapTabView.getSearchBar().text = location.title
                owner.moveMapCamera(to: location.coordinates)
                owner.dismissKeyboard()
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 뒤로가기 버튼 탭
        mapTabView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.changeSelectedIndexDelegate?.changeSelectedIndexToPrevious()
                owner.isRegister = false
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 등록 버튼 탭
        mapTabView.getNavigationBarView().getRightButton().rx.tap
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                // 킥보드 등록
                let lat = owner.cameraCoordinates.lat
                let lng = owner.cameraCoordinates.lng
                let item: RegisterUIModel = .init(latitude: lat, longitude: lng, address: owner.address)
                
                let repository = CreateKickboardRepository()
                let useCaseInterface = CreateKickboardUseCase(repository: repository)
                let viewModel = RegisterViewModel(createKickboardUseCaseInterface: useCaseInterface)
                let registerVC = RegisterViewController(viewModel: viewModel, registerUIModel: item)
                owner.navigationController?.pushViewController(registerVC, animated: true)
            }.disposed(by: disposeBag)
        
        // 킥보드 마커 숨김 버튼 탭
        mapTabView.getHideKickboardButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleMarkerHideState()
            }.disposed(by: disposeBag)
        
        // 검색창 활성화, 검색 결과 표시
        mapTabView.getSearchBar().rx.textDidBeginEditing
            .bind(with: self) { owner, _ in
                owner.mapTabView.updateTableViewHideState(to: false)
            }.disposed(by: disposeBag)
        
        // 검색창 비활성화, 검색 결과 숨김
        mapTabView.getSearchBar().rx.textDidEndEditing
            .bind(with: self) { owner, _ in
                owner.mapTabView.updateTableViewHideState(to: true)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Style Helper
    
    override func setStyles() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.view.addSubview(mapTabView)
        
        mapTabView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Delegate Helper
    
    override func setDelegates() {
        mapTabView.getNaverMapView().mapView.addCameraDelegate(delegate: self)
        mapTabView.getNaverMapView().mapView.touchDelegate = self
    }
    
    // MARK: - Register Helper
    
    override func setRegister() {
        mapTabView.getSearchResultTableView().register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.className)
    }
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// coordinates 위치로 카메라 이동
    func moveMapCamera(to coordinates: CLLocationCoordinate2D) {
        let nmgCoordinate = NMGLatLng(from: coordinates)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgCoordinate, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        
        let mapView = mapTabView.getNaverMapView().mapView
        DispatchQueue.main.async {
            mapView.moveCamera(cameraUpdate)
        }
    }
    
    /// 킥보드 마커 생성
    func makeMarkerList(of data: [Kickboard]) -> [NMFMarker] {
        let markerList = data.map {
            let marker = NMFMarker()
            marker.width = 45
            marker.height = 45
            marker.position = .init(lat: $0.latitude, lng: $0.longitude)
            marker.anchor = CGPoint(x: 0.5, y: 0.45)
            marker.minZoom = 12.0
            marker.maxZoom = 18.0
            marker.isMaxZoomInclusive = true
            marker.userInfo = [
                "id": $0.id,
                "latitude": $0.latitude,
                "longtitude": $0.longitude,
                "battery": $0.battery,
                "status": $0.status
            ]
            
            let iconImage: NMFOverlayImage
            switch $0.status {
            case KickboardStatus.able.rawValue:
                iconImage = .init(image: .kickboardMarkerAvailableShadow)
            case KickboardStatus.declared.rawValue:
                iconImage = .init(image: .kickboardMarkerDeclaredShadow)
            case KickboardStatus.lowBattery.rawValue:
                iconImage = .init(image: .kickboardMarkerUnavailableShadow)
            default:  // IMPOSSIBILITY
                iconImage = .init(image: .kickboardMarkerUnavailableShadow)
                marker.hidden = true
            }
            marker.iconImage = iconImage
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                overlay.userInfo["id"]
                let modalVC = MapModalViewController()
                // TODO: 킥보드 사용 모달 구현
                return true
            }
            
            return marker
        }
        
        return markerList
    }
    
    /// 마커 숨김 상태 변경
    func toggleMarkerHideState() {
        isAllMarkerHidden.toggle()
        kickboardMarkerList
            .filter { $0.userInfo["status"] as! String != KickboardStatus.impossibility.rawValue }
            .forEach { $0.hidden = isAllMarkerHidden }
    }
    
    /// 키보드 내림
    func dismissKeyboard() {
        mapTabView.getSearchBar().resignFirstResponder()
    }
    
    func makeAddress(location: ReverseGeoResultModel) -> String {
        let region = location.region
        let land = location.land
        
        var address = "\(region.area1.name) \(region.area2.name)"
        if let roadName = land?.name, let roadNum = land?.number1 {
            // 도로명 주소
            address += " \(roadName) \(roadNum)"
        } else {
            // 지번 주소
            address += " \(region.area3.name)"
            if !region.area4.name.isEmpty {
                address += " \(region.area4.name)"
            }
            if let addrNum1 = land?.number1, let addrNum2 = land?.number2 {
                address += " \(addrNum1) \(addrNum2)"
            }
        }
        
        if let buildingName = land?.addition0.value {
            // + 건물 이름
            address += " \(buildingName)"
        }
        
        return address
    }
}

// MARK: - NMFMapViewCameraDelegate

extension MapTabViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라가 현위치를 추적하는 것을 멈춤
        if reason == NMFMapChangedByGesture {
            mapPositionMode = .normal
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let coordinates = mapView.cameraPosition.target
        cameraCoordinates = coordinates
        if isRegister {
            viewModel.action.onNext(.mapViewCameraIdle(lat: coordinates.lat, lng: coordinates.lng))
        }
    }
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        // 키보드 내리기
        dismissKeyboard()
    }
}


// TODO: 지도 뷰 켜졌을 때 탑승중인 킥보드 있는지 확인
