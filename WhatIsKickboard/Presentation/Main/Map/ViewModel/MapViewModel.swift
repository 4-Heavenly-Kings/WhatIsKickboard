//
//  MapViewModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import Foundation
import CoreLocation
import OSLog

import RxSwift

final class MapViewModel: NSObject, ViewModelProtocol {

    // MARK: - Properties
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MapViewModel")
    
    // MARK: - Action ➡️ Input
    
    enum Action {
        case mapLoaded
    }
    var action: AnyObserver<Action> {
        return state.actionSubject.asObserver()
    }
    
    // MARK: - Output ➡️ State
    
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
    }
    var state = State()
    
    var disposeBag = DisposeBag()
    
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
    }
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        
        state.actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .mapLoaded:
                    owner.checkDeviceLocationService()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Location Methods

private extension MapViewModel {
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
    
    func checkUserCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            os_log(.debug, log: log, "위치 서비스 권한: 허용됨")
            locationManager.startUpdatingLocation()
            guard let coordinate = locationManager.location?.coordinate else { return }
            let logMsg = "현재 위치: (latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)"
            os_log(.debug, log: log, "현재 위치: %@", logMsg)
            break
        case .restricted, .denied:
            os_log(.debug, log: log, "위치 서비스 권한: 차단됨")
            break
        case .notDetermined:
            os_log(.debug, log: log, "위치 서비스 권한: 설정 필요")
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let logMsg = "현재 위치: (latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)"
        os_log(.debug, log: log, "현재 위치: %@", logMsg)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let logMsg = error.localizedDescription
        os_log(.error, log: log, "위치 정보를 받아오는 데 실패함: %@", logMsg)
    }
}
