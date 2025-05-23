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
import UniformTypeIdentifiers

enum MapTabViewMode {
    case map
    case registerKickboard
    case touchKickboard
    case usingKickboard
    case returnKickboard
}

enum BatteryImage {
    case toTen
    case toThirty
    case toSeventy
    case toNinety
    case toHundred
    
    var image: UIImage? {
        switch self {
        case .toTen:
            return UIImage(systemName: "battery.0percent")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
        case .toThirty:
            return UIImage(systemName: "battery.25percent")
        case .toSeventy:
            return UIImage(systemName: "battery.50percent")
        case .toNinety:
            return UIImage(systemName: "battery.75percent")
        case .toHundred:
            return UIImage(systemName: "battery.100percent")
        }
    }
}

/// 지도 탭 ViewController
final class MapTabViewController: BaseViewController {
    
    // MARK: - Properties
    
    /// MapTabViewController 현재 모드
    let currentModeRelay = BehaviorRelay<MapTabViewMode>(value: .map)
    
    private let viewModel: MapTabViewModel
    
    /// 선택한 킥보드 정보
    private var selectedKickboard: Kickboard?
    /// 지도 애니메이션 상태 관리용
    private var mapPositionMode: NMFMyPositionMode = .disabled
    /// 킥보드 마커 리스트
    private var kickboardMarkerList = [UUID: NMFMarker]()
    /// 킥보드 마커 숨김 상태
    private var isAllMarkerHidden: Bool = false {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let buttonImage = UIImage(systemName: isAllMarkerHidden ? "eye" : "eye.slash", withConfiguration: config)
            mapTabView.getHideKickboardButton().setImage(buttonImage, for: .normal)
        }
    }

    /// 사용자 위치 좌표
    private var userCoordinates = CLLocationCoordinate2D()
    /// 지도 카메라 좌표
    private var cameraCoordinates = NMGLatLng()
    /// 검색창 주소
    private var address = ""
    
    /// TabBarController 관련 Delegate
    weak var changeSelectedIndexDelegate: ChangeSelectedIndexDelegate?
    
    // 반납 관련 프로퍼티
    private var customAlertView: CustomAlertView?
    private var returnPrice: Int = 0
    private var returnBattery: Int = 0
    private var returnMinutes: Int = 0
    
    // MARK: - UI Components
    
    /// 지도 탭 View
    private let mapTabView = MapTabView()
    
    init(viewModel: MapTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentModeRelay.accept(.map)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        // MapTabViewController 현재 모드 설정
        currentModeRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, mode in
                switch mode {
                case .map:
                    // 킥보드 마커, 탭바
                    owner.mapTabView.currentModeRelay.accept(.map)
                    owner.changeMarkerHideState(to: false)
                    owner.tabBarController?.tabBar.isHidden = false
                case .registerKickboard:
                    // 카메라 멈춤, 카메라 좌표로 주소 검색
                    owner.mapPositionMode = .normal
                    owner.mapTabView.currentModeRelay.accept(.registerKickboard)
                    owner.viewModel.action.onNext(.searchCoords(lat: owner.cameraCoordinates.lat, lng: owner.cameraCoordinates.lng))
                    owner.tabBarController?.tabBar.isHidden = true
                case .touchKickboard:
                    // 카메라 멈춤
                    owner.mapPositionMode = .normal
                    owner.mapTabView.currentModeRelay.accept(.touchKickboard)
                    owner.tabBarController?.tabBar.isHidden = true
                case .usingKickboard:
                    // 카메라 사용자 따라가기
                    owner.mapPositionMode = .direction
                    owner.mapTabView.currentModeRelay.accept(.usingKickboard)
                    owner.changeMarkerHideState(to: true)
                case .returnKickboard:
                    owner.mapTabView.currentModeRelay.accept(.returnKickboard)
                }
            }).disposed(by: disposeBag)
        
        
        // ViewModel ➡️ State
        // 사용자 위치로 카메라 이동
        viewModel.state.userLocation
            .compactMap { $0 }
            .bind(with: self) { owner, coordinates in
                owner.userCoordinates = coordinates
                
                let mapView = owner.mapTabView.getNaverMapView().mapView
                // 앱 실행 시 카메라 추적 모드
                if mapView.positionMode == .disabled {
                    mapView.positionMode = .normal
                    owner.mapPositionMode = .direction
                }
                
                if owner.mapPositionMode == .direction {
                    owner.moveMapCamera(lat: coordinates.latitude, lng: coordinates.longitude)
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
                // 마커 삭제
                owner.kickboardMarkerList.forEach {
                    $0.value.mapView = nil
                }
                owner.kickboardMarkerList.removeAll()
                
                // 변경된 마커 업데이트
                markerList.forEach {
                    owner.kickboardMarkerList[$0.userInfo["id"] as! UUID] = $0
                }
                
                // 지도에 표시
                owner.kickboardMarkerList.forEach {
                    if $0.value.mapView == nil {
                        $0.value.mapView = owner.mapTabView.getNaverMapView().mapView
                    }
                }
            }.disposed(by: disposeBag)
        
        // 장소 검색 결과 표시
        viewModel.state.locationSearchResult
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] locationList in
                guard let self else { return }
                
                let totalHeight = locationList.count * 40
                self.mapTabView.updateTableViewAppearance(heightTo: totalHeight)
            })
            .drive(mapTabView.getSearchResultTableView().rx.items(
                cellIdentifier: SearchResultCell.className,
                cellType: SearchResultCell.self)) { _, location, cell in
                    cell.configure(location: location)
                }.disposed(by: disposeBag)
        
        // 좌표 검색 결과 표시
        viewModel.state.reverseGeoSearchResult
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, location in
                if let nearest = location.first {
                    owner.address = owner.makeAddress(location: nearest)
                } else {
                    owner.address = ""
                }
                owner.mapTabView.getSearchBar().text = owner.address
            }.disposed(by: disposeBag)
        
        // 킥보드 사용 시간 업데이트
        viewModel.state.elapsedSeconds
            .asDriver()
            .drive(with: self) { owner, elapsedSeconds in
                owner.mapTabView.updateUsingTimeLabel(elapsedSeconds: elapsedSeconds)
            }.disposed(by: disposeBag)
        
        
        // Action ➡️ ViewModel
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didLocationButtonTap)
            }.disposed(by: disposeBag)
        
        // 킥보드 신고 버튼 탭
        mapTabView.getDeclareButton().rx.tap
            .bind(with: self) { owner, _ in
                guard let selectedKickboard = owner.selectedKickboard else { return }
                let alert = UIAlertController(title: "킥보드 신고", message: "킥보드를 신고하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "신고", style: .destructive, handler: { _ in
                    owner.viewModel.action.onNext(.didDeclareButtonTap(id: selectedKickboard.id))
                    owner.currentModeRelay.accept(.map)
                }))
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        // 장소 검색창 텍스트 전달
        mapTabView.getSearchBar().rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.viewModel.action.onNext(.searchText(text: text))
            }.disposed(by: disposeBag)
        
        // 킥보드 반납 모달 표시
        Observable
            .combineLatest(viewModel.state.kickboardRide, viewModel.state.user)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] kickboard, user in
                self?.showCustomAlert(user: user, kickboard: kickboard)
            }
            .disposed(by: disposeBag)
        
        // 에러 핸들링
        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind { error in
                print("오류 발생: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        // 바인딩 완료 알림
        viewModel.action.onNext(.getKickboardList)
        
        
        // View ➡️ ViewController
        // 킥보드 마커 숨김 버튼 탭
        mapTabView.getHideKickboardButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.changeMarkerHideState(to: !owner.isAllMarkerHidden)
            }.disposed(by: disposeBag)
        
        // 검색 결과 탭
        mapTabView.getSearchResultTableView().rx
            .modelSelected(LocationModel.self)
            .bind(with: self) { owner, location in
                // 지도 카메라 이동
                owner.mapPositionMode = .normal
                owner.mapTabView.getSearchBar().text = location.title
                owner.moveMapCamera(lat: location.coordinates.latitude, lng: location.coordinates.longitude)
                owner.dismissKeyboard()
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 뒤로가기 버튼 탭
        mapTabView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.changeSelectedIndexDelegate?.changeSelectedIndexToPrevious()
                owner.currentModeRelay.accept(.map)
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 등록 버튼 탭
        mapTabView.getNavigationBarView().getRightButton().rx.tap
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                if owner.address != "" {
                    // 킥보드 등록
                    let lat = owner.cameraCoordinates.lat
                    let lng = owner.cameraCoordinates.lng
                    let item: RegisterUIModel = .init(latitude: lat, longitude: lng, address: owner.address)
                    
                    let repository = CreateKickboardRepository()
                    let useCaseInterface = CreateKickboardUseCase(repository: repository)
                    let viewModel = RegisterViewModel(createKickboardUseCaseInterface: useCaseInterface)
                    let registerVC = RegisterViewController(viewModel: viewModel, registerUIModel: item)
                    registerVC.updateKickboardListDelegate = self
                    owner.navigationController?.pushViewController(registerVC, animated: true)
                } else {
                    let alert = UIAlertController(title: "입력된 장소 없음", message: "장소를 입력해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    owner.present(alert, animated: true)
                }
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
        
        // 대여하기 or 반납하기 버튼 탭
        mapTabView.getRentOrReturnButton().rx.tap
            .bind(with: self) { owner, _ in
                if owner.currentModeRelay.value == .touchKickboard {
                    // 킥보드 대여
                    guard let selectedKickboard = owner.selectedKickboard else { return }
                    
                    owner.viewModel.action.onNext(.didRentButtonTap(id: selectedKickboard.id,
                                                                    latitude: selectedKickboard.latitude,
                                                                    longitude: selectedKickboard.longitude,
                                                                    address: selectedKickboard.address))
                    
                    owner.currentModeRelay.accept(.usingKickboard)
                } else {
                    // 킥보드 반납
                    owner.viewModel.action.onNext(.requestReturn)
                }
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
    
    // MARK: - Register Helper
    
    override func setRegister() {
        mapTabView.getSearchResultTableView().register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.className)
    }
}

// MARK: - Marker Methods

private extension MapTabViewController {
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
                "longitude": $0.longitude,
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
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self else { return true }
                self.makeMarkerTouchHandler(overlay: overlay)
                return true
            }
            
            return marker
        }
        
        return markerList
    }
    
    /// 마커 눌렀을 때 핸들러 생성
    func makeMarkerTouchHandler(overlay: NMFOverlay) {
        if currentModeRelay.value == .map || currentModeRelay.value == .touchKickboard {
            currentModeRelay.accept(.touchKickboard)
            
            let id = overlay.userInfo["id"] as! UUID
            let latitude = overlay.userInfo["latitude"] as! Double
            let longitude = overlay.userInfo["longitude"] as! Double
            let battery = overlay.userInfo["battery"] as! Int
            let status = overlay.userInfo["status"] as! String
            
            if status == KickboardStatus.declared.rawValue {
                mapTabView.getDeclareButton().isHidden = true
            } else {
                mapTabView.getDeclareButton().isHidden = false
            }
            
            moveMapCamera(lat: latitude, lng: longitude)
            
            selectedKickboard = Kickboard(id: id,
                                          latitude: latitude,
                                          longitude: longitude,
                                          battery: battery,
                                          address: address,
                                          status: status)
            
            let usingKickboardView = self.mapTabView.getMapUsingKickboardView()
            let rentOrReturnButton = self.mapTabView.getRentOrReturnButton()
            
            switch battery {
            case 0...10:
                usingKickboardView.batteryImageView.image = BatteryImage.toTen.image
            case 11...30:
                usingKickboardView.batteryImageView.image = BatteryImage.toThirty.image
            case 31...70:
                usingKickboardView.batteryImageView.image = BatteryImage.toSeventy.image
            case 71...90:
                usingKickboardView.batteryImageView.image = BatteryImage.toNinety.image
            case 91...100:
                usingKickboardView.batteryImageView.image = BatteryImage.toHundred.image
            default:
                usingKickboardView.batteryImageView.image = BatteryImage.toTen.image
            }
            usingKickboardView.batteryLabel.text = "배터리 \(battery)%"
            
            usingKickboardView.do {
                $0.usingTimeLabel.do {
                    let text: String
                    switch status {
                    case KickboardStatus.able.rawValue:
                        text = "사용가능"
                        rentOrReturnButton.backgroundColor = .core
                        rentOrReturnButton.isEnabled = true
                    case KickboardStatus.declared.rawValue:
                        text = "신고 접수 중"
                        rentOrReturnButton.backgroundColor = .placeholderText
                        rentOrReturnButton.isEnabled = false
                    case KickboardStatus.lowBattery.rawValue:
                        text = "배터리 부족"
                        rentOrReturnButton.backgroundColor = .placeholderText
                        rentOrReturnButton.isEnabled = false
                    default:  // IMPOSSIBILITY
                        text = "배터리 부족"
                        rentOrReturnButton.backgroundColor = .placeholderText
                        rentOrReturnButton.isEnabled = false
                    }
                    
                    let attributedText = NSMutableAttributedString.makeAttributedString(
                        text: text,
                        highlightedParts: [
                            (text, .black, UIFont.systemFont(ofSize: 30, weight: .bold)),
                        ]
                    )
                    $0.attributedText = attributedText
                    $0.textAlignment = .center
                    $0.textColor = .black
                }
            }
        }
    }
    
    /// 마커 숨김 상태 변경
    func changeMarkerHideState(to state: Bool) {
        isAllMarkerHidden = state
        kickboardMarkerList
            .filter { $0.value.userInfo["status"] as! String != KickboardStatus.impossibility.rawValue }
            .forEach {
                $0.value.hidden = isAllMarkerHidden
            }
    }
}

// MARK: - Camera Methods

private extension MapTabViewController {
    /// coordinates 위치로 카메라 이동
    func moveMapCamera(lat: Double, lng: Double) {
        let nmgCoordinate = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgCoordinate, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        
        let mapView = mapTabView.getNaverMapView().mapView
        DispatchQueue.main.async {
            mapView.moveCamera(cameraUpdate)
        }
    }
}

// MARK: - Kickboard Methods

private extension MapTabViewController {
    func calculateElapsedMinutes(kickboard: KickboardRide, userId: UUID) -> Int {
        let startTime = kickboard.startTime
        let now = Date()
        let minutes = Calendar.current.dateComponents([.minute], from: startTime, to: now).minute ?? 0
        return minutes
    }
    
    func showCustomAlert(user: User, kickboard: KickboardRide) {
        let name = user.name ?? "이름 없음"
        self.returnMinutes = calculateElapsedMinutes(kickboard: kickboard, userId: user.id)
        self.returnPrice = (returnMinutes * 100) + 500
        self.returnBattery = kickboard.battery
        
        let alert = CustomAlertView(frame: .zero, alertType: .returnRequest)
        view.addSubview(alert)
        alert.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        alert.configure(
            name: name,
            minutes: returnMinutes,
            count: nil,
            price: "\(returnPrice)"
        )
        
        alert.getSubmitButton().rx.tap
            .bind { [weak self, weak alert] in
                self?.currentModeRelay.accept(.returnKickboard)
                alert?.removeFromSuperview()
                self?.customAlertView = nil
                self?.openCamera()
            }
            .disposed(by: disposeBag)
        
        alert.getCancelButton().rx.tap
            .bind { [weak self, weak alert] in
                alert?.removeFromSuperview()
                self?.customAlertView = nil
            }
            .disposed(by: disposeBag)
        
        self.customAlertView = alert
    }
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// 키보드 내림
    func dismissKeyboard() {
        mapTabView.getSearchBar().resignFirstResponder()
    }
    
    /// 주소 조합
    func makeAddress(location: ReverseGeoResultModel) -> String {
        let region = location.region
        let land = location.land
        
        var address = "\(region.area1.name) \(region.area2.name)"
        if let roadName = land?.name, let roadNum = land?.number1 {
            // 도로명 주소
            address += " \(roadName) \(roadNum)"
        } else {
            // 지번 주소
            address += " \(region.area3.name)"
            if !region.area4.name.isEmpty {
                address += " \(region.area4.name)"
            }
            if let addrNum1 = land?.number1, let addrNum2 = land?.number2 {
                address += " \(addrNum1) \(addrNum2)"
            }
        }
        
        return address
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
    
    // 카메라 움직임이 Idle일 때 좌표 검색
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let coordinates = mapView.cameraPosition.target
        cameraCoordinates = coordinates
        
        if currentModeRelay.value == .registerKickboard {
            viewModel.action.onNext(.searchCoords(lat: coordinates.lat, lng: coordinates.lng))
        }
    }
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        dismissKeyboard()
        if currentModeRelay.value != .registerKickboard && currentModeRelay.value != .usingKickboard {
            currentModeRelay.accept(.map)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MapTabViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("카메라 사용 불가")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = [UTType.image.identifier]
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                if let imagePath = self.saveImageToDocuments(image: image) {
                    let repository = ReturnKickboardRepository()
                    let useCaseInterface = ReturnKickboardUseCase(repository: repository)
                    let viewModel = ReturnViewModel(returnKickboardUseCaseInterface: useCaseInterface)
                    let returnUIModel = ReturnUIModel(
                        imagePath: imagePath,
                        price: self.returnPrice,
                        battery: self.returnBattery,
                        returnMinutes: self.returnMinutes,
                        latitude: self.userCoordinates.latitude,
                        longitude: self.userCoordinates.longitude,
                        address: self.address
                    )
                    let returnVC = ReturnViewController(viewModel: viewModel, returnUIModel: returnUIModel)
                    returnVC.refreshKickboardListDelegate = self
                    self.navigationController?.pushViewController(returnVC, animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let filename = UUID().uuidString + ".jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("이미지 저장 실패: \(error)")
            return nil
        }
    }
}

extension MapTabViewController: UpdateKickboardListDelegate {
    func updateKickboardList() {
        if currentModeRelay.value == .returnKickboard {
            currentModeRelay.accept(.map)
        }
        viewModel.action.onNext(.getKickboardList)
    }
}
