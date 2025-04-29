//
//  MapViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit
import CoreLocation

import NMapsMap
import SnapKit
import Then

final class MapViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel = MapViewModel()
    
    // MARK: - UI Components
    
    private let mapView = MapView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        viewModel.action.onNext(.mapLoaded)
    }
    
    // MARK: - Style Helper
    
    override func setStyles() {
        self.view.backgroundColor = .white
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        self.view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
