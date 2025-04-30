//
//  MapTabViewModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/28/25.
//

import Foundation
import CoreLocation
import OSLog

import RxRelay
import RxSwift

final class MapTabViewModel: NSObject, ViewModelProtocol {
    
    // MARK: - Properties
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MapViewModel")
    /// 킥보드 목업 데이터
    private let mockKickboard = Kickboard(id: UUID(), latitude: 37.2064, longitude: 127.0681, battery: 80, status: "ABLE")
    /// Core Location Manager
    private let locationManager = CLLocationManager()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Action (ViewController ➡️ ViewModel)
    
    enum Action {
        /// 바인딩 완료
        case didBinding
        /// 현재 위치 버튼 탭
        case didlocationButtonTap
    }
    var action: AnyObserver<Action> {
        return state.actionSubject.asObserver()
    }
    
    // MARK: - State (ViewModel ➡️ ViewController)
    
    struct State {
        /// ViewController에서 받은 action
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        /// Core Location 사용자 위치 좌표
        fileprivate(set) var userLocation = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
        /// 킥보드 리스트
        fileprivate(set) var kickboardList = BehaviorRelay<[Kickboard]>(value: [])
    }
    var state = State()
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        
        locationManager.do {
            $0.delegate = self
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.requestWhenInUseAuthorization()
        }
        
        state.actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .didBinding:
                    owner.updateKickboardList()
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
    
    /// 킥보드 리스트 ViewController로 전달
    func updateKickboardList() {
        state.kickboardList.accept(mockKickboard.getMockList())
    }
    
    /// 최근 업데이트된 좌표 ViewController로 전달
    func updateLastLocation() {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        let logMsg = "현재 위치: (latitude: \(latitude ?? 0.0), longitude: \(longitude ?? 0.0))"
        os_log(.debug, log: log, "%@", logMsg)
        state.userLocation.accept(locationManager.location?.coordinate)
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
