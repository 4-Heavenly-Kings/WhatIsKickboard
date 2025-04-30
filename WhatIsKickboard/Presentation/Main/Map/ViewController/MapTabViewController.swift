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
            .bind(with: self) { owner, coordinate in
                let mapView = owner.mapTabView.getNaverMapView().mapView
                if mapView.positionMode == .disabled {
                    mapView.positionMode = .normal
                    owner.mapPositionMode = .direction
                }
                
                if owner.mapPositionMode == .direction {
                    owner.moveMapCamera(to: coordinate)
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
        viewModel.state.searchResult
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] locationList in
                guard let self else { return }
                
                let totalHeight = locationList.count * 40
                self.mapTabView.updateTableViewAppearance(heightTo: totalHeight)
            })
            .drive(mapTabView.getSearchResultTableView().rx.items(
                cellIdentifier: SearchResultCell.identifier,
                cellType: SearchResultCell.self)) { _, location, cell in
                    cell.configure(location: location)
            }.disposed(by: disposeBag)
        
        // 검색 결과 탭
        mapTabView.getSearchResultTableView().rx
            .modelSelected(LocationModel.self)
            .bind(with: self) { owner, location in
                if owner.isRegister {
                    // 킥보드 등록
                    let registerVC = RegisterViewController()
                    owner.navigationController?.pushViewController(registerVC, animated: true)
                } else {
                    // 지도 카메라 이동
                    owner.moveMapCamera(to: location.coordinate)
                }
            }.disposed(by: disposeBag)
        
        
        // Action ➡️ ViewModel
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didlocationButtonTap)
            }.disposed(by: disposeBag)
        
        // 장소 검색창 텍스트 및 위치 전달
        mapTabView.getSearchBar().rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.viewModel.action.onNext(.searchText(text: text))
            }.disposed(by: disposeBag)
        
        // 바인딩 완료 알림
        viewModel.action.onNext(.didBinding)
        
        
        // View ➡️ ViewController
        // 킥보드 위치 등록 화면 뒤로가기 버튼 탭
        mapTabView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.changeSelectedIndexDelegate?.changeSelectedIndexToPrevious()
                owner.isRegister = false
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
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// coordinate 위치로 카메라 이동
    func moveMapCamera(to coordinate: CLLocationCoordinate2D) {
        let nmgCoordinate = NMGLatLng(from: coordinate)
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
}

// MARK: - NMFMapViewCameraDelegate

extension MapTabViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라가 현위치를 추적하는 것을 멈춤
        if reason == NMFMapChangedByGesture {
            mapPositionMode = .normal
        }
    }
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        // 키보드 내리기
        mapTabView.getSearchBar().resignFirstResponder()
    }
}
