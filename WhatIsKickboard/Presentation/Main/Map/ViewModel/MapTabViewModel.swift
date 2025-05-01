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

/// 지도 탭 ViewModel
final class MapTabViewModel: NSObject, ViewModelProtocol {
    
    // MARK: - Properties
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MapViewModel")
    /// 킥보드 목업 데이터
    private let mockKickboard = Kickboard(id: UUID(), latitude: 37.2064, longitude: 127.0681, battery: 80, address: "서울특별시 종로구 세종대로 175", status: "ABLE")
    /// Core Location Manager
    private let locationManager = CLLocationManager()
    
    private let fetchAPIGeocodingUseCase = FetchAPIGeocodingUseCase()
    private let fetchAPIReverseGeocodingUseCase = FetchAPIReverseGeocodingUseCase()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Action (ViewController ➡️ ViewModel)
    
    enum Action {
        /// 현재 위치 버튼 탭
        case didlocationButtonTap
        /// 장소 검색창 텍스트
        case searchText(text: String)
        /// 카메라 아이들 상태일 때 Reverse Geocoding 검색
        case mapViewCameraIdle(lat: Double, lng: Double)
        /// 바인딩 완료
        case didBinding
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
        /// 장소 검색 결과
        fileprivate(set) var locationSearchResult = PublishRelay<[LocationModel]>()
        /// Reverse Geocoding 검색 결과
        fileprivate(set) var reverseGeoSearchResult = PublishRelay<[ReverseGeoResultModel]>()
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
                case .didlocationButtonTap:
                    owner.updateLastLocation()
                case let .searchText(text):
                    owner.searchLocation(searchText: text)
                case let .mapViewCameraIdle(lat, lng):
                    owner.searchCoords(lat: lat, lng: lng)
                case .didBinding:
                    owner.updateKickboardList()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - Map Methods

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
        let lat = locationManager.location?.coordinate.latitude
        let lng = locationManager.location?.coordinate.longitude
        let logMsg = "현재 위치: (latitude: \(lat ?? 0.0), longitude: \(lng ?? 0.0))"
        os_log(.debug, log: log, "%@", logMsg)
        state.userLocation.accept(locationManager.location?.coordinate)
    }
}

// MARK: - Location Methods

private extension MapTabViewModel {
    /// API를 통한 장소 검색
    func searchLocation(searchText: String) {
        fetchAPIGeocodingUseCase.fetchSearchResults(for: searchText)
            .subscribe(with: self, onSuccess: { owner, locations in
                owner.state.locationSearchResult.accept(locations)
            }, onFailure: { owner, error in
                owner.state.locationSearchResult.accept([])
                os_log(.error, log: owner.log, "장소 검색 실패: %@", "\(error)")
            }).disposed(by: disposeBag)
    }
    
    func searchCoords(lat: Double, lng: Double) {
        let coordinates = "\(lng),\(lat)"
        fetchAPIReverseGeocodingUseCase.fetchCoordToAddress(coords: coordinates)
            .subscribe(with: self, onSuccess: { owner, results in
                owner.state.reverseGeoSearchResult.accept(results)
            }, onFailure: { owner, error in
                owner.state.reverseGeoSearchResult.accept([])
            }).disposed(by: disposeBag)
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
