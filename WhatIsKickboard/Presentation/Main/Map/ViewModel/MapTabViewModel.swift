//
//  MapTabViewModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import Foundation
import CoreLocation
import OSLog

import RxSwift

final class MapTabViewModel: NSObject, ViewModelProtocol {

    // MARK: - Properties
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MapViewModel")
    
    var disposeBag = DisposeBag()
    
    /// Core Location
    private let locationManager = CLLocationManager().then {
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
    }
    
    // MARK: - Action ➡️ Input
    
    enum Action {
        case didBinding
        case didlocationButtonTap
    }
    var action: AnyObserver<Action> {
        return state.actionSubject.asObserver()
    }
    
    // MARK: - Output ➡️ State
    
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        /// Core Location 사용자 위치 좌표
        fileprivate(set) var userLocation = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
        /// 킥보드 리스트
        fileprivate(set) var kickboardList = BehaviorSubject<[Kickboard]>(value: [])
    }
    var state = State()
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        
        let mockKickboard = Kickboard(id: UUID(),
                                  latitude: 37.20641977176015,
                                  longitude: 127.06812295386771,
                                  battery: 80,
                                  status: "ABLE")
        
        state.actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .didBinding:
                    owner.state.kickboardList.onNext(mockKickboard.getMockList())
                case .didlocationButtonTap:
                    owner.updateLastLocation()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Location Methods

private extension MapTabViewModel {
    /// 디바이스 위치 서비스가 활성화 상태인지 확인
    func checkDeviceLocationService() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            if CLLocationManager.locationServicesEnabled() {
                os_log(.debug, log: log, "디바이스 위치 서비스: On 상태")
                let status: CLAuthorizationStatus = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.checkUserCurrentLocationAuthorization(status: status)
                }
            } else {
                os_log(.debug, log: log, "디바이스 위치 서비스: Off 상태")
            }
        }
    }
    
    /// 앱 위치 서비스 권한 확인
    func checkUserCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            os_log(.debug, log: log, "위치 서비스 권한: 허용됨")
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            os_log(.debug, log: log, "위치 서비스 권한: 차단됨")
        case .notDetermined:
            os_log(.debug, log: log, "위치 서비스 권한: 설정 필요")
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func updateLastLocation() {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        let logMsg = "현재 위치: (latitude: \(latitude ?? 0.0)), longitude: \(longitude ?? 0.0))"
        os_log(.debug, log: log, "%@", logMsg)
        state.userLocation.onNext(locationManager.location?.coordinate)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLastLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let logMsg = error.localizedDescription
        os_log(.error, log: log, "위치 정보를 받아오는 데 실패함: %@", logMsg)
    }
}
