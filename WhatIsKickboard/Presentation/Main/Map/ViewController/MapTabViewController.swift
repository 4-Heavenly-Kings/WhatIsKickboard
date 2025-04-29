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

final class MapTabViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = MapTabViewModel()
    /// 지도 애니메이션 상태 관리용
    private var mapPositionMode: NMFMyPositionMode = .disabled
    /// 킥보드 마커 리스트
    private var kickboardMarkerList = [NMFMarker]()
    
    // MARK: - UI Components
    
    /// 지도 탭 View
    private let mapTabView = MapTabView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                owner.updateMapCamera(to: coordinate)
            }.disposed(by: disposeBag)
        
        // 킥보드 마커 생성
        viewModel.state.kickboardList
            .withUnretained(self)
            .map { owner, kickboardList in
                kickboardList.map { data in
                    return owner.makeMarker(of: data)
                }
            }
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
        
        // Action ➡️ ViewModel
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didlocationButtonTap)
            }.disposed(by: disposeBag)
        
        // 바인딩 완료 알림
        viewModel.action.onNext(.didBinding)
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
    
    override func setDelegates() {
        mapTabView.getNaverMapView().mapView.addCameraDelegate(delegate: self)
    }
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// coordinate 위치로 카메라 이동
    func updateMapCamera(to coordinate: CLLocationCoordinate2D) {
        if mapPositionMode == .direction {
            let nmgCoordinate = NMGLatLng(from: coordinate)
            let cameraUpdate = NMFCameraUpdate(scrollTo: nmgCoordinate, zoomTo: 15)
            cameraUpdate.animation = .easeIn
            
            let mapView = mapTabView.getNaverMapView().mapView
            DispatchQueue.main.async {
                mapView.moveCamera(cameraUpdate)
            }
        }
    }
    
    func makeMarker(of data: Kickboard) -> NMFMarker {
        let marker = NMFMarker()
        marker.width = 45
        marker.height = 45
        marker.position = .init(lat: data.latitude, lng: data.longitude)
        marker.anchor = CGPoint(x: 0.5, y: 0.45)
        marker.minZoom = 12.0
        marker.maxZoom = 18.0
        marker.isMaxZoomInclusive = true
        marker.userInfo = [
            "id": data.id,
            "latitude": data.latitude,
            "longtitude": data.longitude,
            "battery": data.battery,
            "status": data.status
        ]
        
        let iconImage: NMFOverlayImage
        switch data.status {
        case KickboardStatus.able.rawValue:
            iconImage = .init(name: "KickboardMarker_Available.svg")
        case KickboardStatus.declared.rawValue:
            iconImage = .init(name: "KickboardMarker_Declared.svg")
        case KickboardStatus.lowBattery.rawValue:
            iconImage = .init(name: "KickboardMarker_Unavailable.svg")
        default:  // IMPOSSIBILITY
            iconImage = .init(name: "KickboardMarker_Unavailable.svg")
            marker.hidden = true
        }
        marker.iconImage = iconImage
        
        return marker
    }
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            mapPositionMode = .normal
        }
    }
}
