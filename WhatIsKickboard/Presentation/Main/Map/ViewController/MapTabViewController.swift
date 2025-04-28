//
//  MapTabViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit
import CoreLocation

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

final class MapTabViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = MapTabViewModel()
    private var disposeBag = DisposeBag()
    /// 지도 애니메이션 상태 관리용
    private var mapPositionMode: NMFMyPositionMode = .disabled
    
    // MARK: - UI Components
    
    /// 지도 탭 View
    private let mapTabView = MapTabView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didlocationButtonTap)
            }.disposed(by: disposeBag)
        
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
    /// coordinate 위치로 카메라 전환
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
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            mapPositionMode = .normal
        }
    }
}
