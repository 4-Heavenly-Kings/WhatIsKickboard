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
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MapTabViewModel")

    /// Core Location Manager
    private let locationManager = CLLocationManager()
    
    private let getKickboardListUseCase: GetKickboardListUseCase
    private let declareKickboardUseCase: DeclareKickboardUseCase
    private let fetchAPIGeocodingUseCase: FetchAPIGeocodingUseCase
    private let rentKickboardUseCase: RentKickboardUseCase
    private let returnRequestUseCaseInterface: ReturnRequestUseCaseInterface
    
    private var storedKickboardId: UUID?
    
    /// 킥보드 사용 시간 측정용
    private var timer: Timer?
    private var elapsedSeconds = 0
    
    var disposeBag = DisposeBag()
    
    // MARK: - Action (ViewController ➡️ ViewModel)
    
    enum Action {
        /// 현재 위치 버튼 탭
        case didLocationButtonTap
        /// 킥보드 신고 버튼 탭
        case didDeclareButtonTap(id: UUID)
        /// 장소 검색창 텍스트
        case searchText(text: String)
        /// 카메라 아이들 상태일 때 Reverse Geocoding 검색
        case searchCoords(lat: Double, lng: Double)
        /// 킥보드 대여
        case didRentButtonTap(id: UUID, latitude: Double, longitude: Double, address: String)
        /// 킥보드 반납
        case requestReturn
        /// 바인딩 완료
        case getKickboardList
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
        fileprivate(set) var reverseGeoSearchResult = BehaviorRelay<[ReverseGeoResultModel]>(value: [])
        /// 킥보드 사용 시간
        fileprivate(set) var elapsedSeconds = BehaviorRelay<Int>(value: 0)
        
        let kickboardRide = PublishRelay<KickboardRide>()
        let user = PublishRelay<User>()
        let error = PublishRelay<Error>()
    }
    var state = State()
    
    // MARK: - Initializer
    
    init(getKickboardListUseCase: GetKickboardListUseCase,
         declareKickboardUseCase: DeclareKickboardUseCase,
         fetchAPIGeocodingUseCase: FetchAPIGeocodingUseCase,
         rentKickboardUseCase: RentKickboardUseCase,
         returnRequestUseCaseInterface: ReturnRequestUseCaseInterface
    ) {
        self.getKickboardListUseCase = getKickboardListUseCase
        self.declareKickboardUseCase = declareKickboardUseCase
        self.fetchAPIGeocodingUseCase = fetchAPIGeocodingUseCase
        self.rentKickboardUseCase = rentKickboardUseCase
        self.returnRequestUseCaseInterface = returnRequestUseCaseInterface
        
        super.init()
        
        locationManager.do {
            $0.delegate = self
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.requestWhenInUseAuthorization()
        }
        
        state.actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .didLocationButtonTap:
                    owner.updateLastLocation()
                case let .didDeclareButtonTap(id: id):
                    owner.declareKickboard(id: id)
                case let .searchText(text):
                    owner.searchLocation(searchText: text)
                case let .searchCoords(lat, lng):
                    owner.searchCoords(lat: lat, lng: lng)
                case let .didRentButtonTap(id, latitude, longitude, address):
                    owner.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
                case .requestReturn:
                    owner.handleReturnRequest()
                case .getKickboardList:
                    owner.updateKickboardList()
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: - @objc Methods

@objc private extension MapTabViewModel {
    func updateTimer() {
        elapsedSeconds += 1
        state.elapsedSeconds.accept(elapsedSeconds)
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
    
    /// 최근 업데이트된 좌표 ViewController로 전달
    func updateLastLocation() {
        let lat = locationManager.location?.coordinate.latitude
        let lng = locationManager.location?.coordinate.longitude
        let logMsg = "현재 위치: (latitude: \(lat ?? 0.0), longitude: \(lng ?? 0.0))"
        os_log(.debug, log: log, "%@", logMsg)
        state.userLocation.accept(locationManager.location?.coordinate)
    }
}

// MARK: - Kickboard Methods

private extension MapTabViewModel {
    /// 킥보드 리스트 MapTabViewController로 전달
    func updateKickboardList() {
        getKickboardListUseCase.getKickboardList()
            .subscribe(with: self) { owner, kickboardList in
                owner.state.kickboardList.accept(kickboardList)
            }.disposed(by: disposeBag)
    }
    
    /// 킥보드 신고 정보 Core Data에 전달
    func declareKickboard(id: UUID) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.declareKickboardUseCase.declareKickboard(id: id)
                self.updateKickboardList()
            } catch {
                os_log(.error, log: log, "킥보드 신고 실패: %@", "\(error.localizedDescription)")
            }
        }
    }
    
    /// 킥보드 대여 정보 Core Data에 전달
    func rentKickboard(id: UUID, latitude: Double, longitude: Double, address: String) {
        rentKickboardUseCase.execute(id: id, latitude: latitude, longitude: longitude, address: address)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    /// 킥보드 반납
    func handleReturnRequest() {
        returnRequestUseCaseInterface.getCurrentUser()
            .flatMap { [weak self] user -> Single<(KickboardRide, User)> in
                guard let self = self else {
                    return .error(NSError(domain: "ViewModel deallocated", code: -1))
                }

                guard let rideId = user.currentKickboardRideId else {
                    return .error(NSError(domain: "No current ride ID", code: -2))
                }

                return self.returnRequestUseCaseInterface.getKickboardRide(id: rideId)
                    .map { ride in (ride, user) }
            }
            .subscribe(onSuccess: { [weak self] ride, user in
                self?.state.kickboardRide.accept(ride)
                self?.state.user.accept(user)
            }, onFailure: { [weak self] error in
                self?.state.error.accept(error)
            })
            .disposed(by: disposeBag)
        
        elapsedSeconds = 0
        timer?.invalidate()
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
                os_log(.error, log: owner.log, "장소 검색 실패: %@", "\(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    /// API를 통한 좌표 ➡️ 주소 변환
    func searchCoords(lat: Double, lng: Double) {
        let coordinates = "\(lng),\(lat)"
        fetchAPIGeocodingUseCase.fetchCoordToAddress(coords: coordinates)
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
