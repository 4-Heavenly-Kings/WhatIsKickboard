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
    
    // MARK: - UI Components
    
    private let mapTabView = MapTabView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        mapTabView.getLocationButton().rx.tap
            .withLatestFrom(viewModel.state.userLocation)
            .subscribe(with: self) { owner, coordinate in
                guard let coordinate else { return }
                owner.updateMapCamera(to: coordinate)
                let naverMapView = owner.mapTabView.getNaverMapView()
                switch naverMapView.mapView.positionMode {
                case .direction:
                    naverMapView.mapView.positionMode = .compass
                case .compass:
                    naverMapView.mapView.positionMode = .direction
                default:
                    naverMapView.mapView.positionMode = .direction
                    owner.updateMapCamera(to: coordinate)
                }
            }.disposed(by: disposeBag)
        
        // ViewModel ➡️ State
        // 사용자 위치로 카메라 이동
        viewModel.state.userLocation
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, coordinate in
                guard let coordinate else { return }
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
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// coordinate 위치로 카메라 전환
    func updateMapCamera(to coordinate: CLLocationCoordinate2D) {
        let nmgCoordinate = NMGLatLng(from: coordinate)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgCoordinate)
        cameraUpdate.animation = .easeIn
        
        let naverMapView = mapTabView.getNaverMapView()
        if naverMapView.mapView.positionMode == .disabled ||
            naverMapView.mapView.positionMode == .normal {
            naverMapView.mapView.positionMode = .direction
        }
        
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
}
