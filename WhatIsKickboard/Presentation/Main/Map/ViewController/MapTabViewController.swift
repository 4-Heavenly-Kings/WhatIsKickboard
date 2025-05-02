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

/// 지도 탭 ViewController
final class MapTabViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: MapTabViewModel

    private var selectedKickboard: Kickboard?
    /// 지도 애니메이션 상태 관리용
    private var mapPositionMode: NMFMyPositionMode = .disabled
    /// 킥보드 마커 리스트
    private var kickboardMarkerList = [NMFMarker]()
    /// 킥보드 마커 숨김 상태
    private var isAllMarkerHidden: Bool = false {
        didSet {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
            let buttonImage = UIImage(systemName: isAllMarkerHidden ? "eye" : "eye.slash", withConfiguration: config)
            mapTabView.getHideKickboardButton().setImage(buttonImage, for: .normal)
        }
    }
    /// 킥보드 등록 모드
    var isRegister: Bool = false {
        didSet {
            self.tabBarController?.tabBar.isHidden = isRegister
            mapTabView.getStatusBarBackgroundView().isHidden = !isRegister
            mapTabView.getNavigationBarView().isHidden = !isRegister
            mapTabView.getCenterMarkerImageView().isHidden = !isRegister
            mapTabView.getSearchBar().text = ""
            mapTabView.getSearchBar().snp.remakeConstraints {
                if isRegister {
                    $0.top.equalTo(mapTabView.getNavigationBarView().snp.bottom).offset(10)
                    $0.leading.trailing.equalTo(mapTabView.safeAreaLayoutGuide).inset(15)
                } else {
                    $0.top.equalTo(mapTabView.safeAreaLayoutGuide).inset(10)
                    $0.leading.trailing.equalTo(mapTabView.safeAreaLayoutGuide).inset(15)
                }
            }
        }
    }
    
    private var isUsingKickboard: Bool = false
    
    private var timer: Timer?
    private var elapsedMinutes = 0
    
    /// 지도 카메라 좌표
    private var cameraCoordinates = NMGLatLng()
    /// 검색창 주소
    private var address = ""
    
    private var customAlertView: CustomAlertView?
    private var returnPrice: Int = 0
    private var returnBattery: Int = 0
    private var returnMinutes: Int = 0
    /// TabBarController 관련 Delegate
    weak var changeSelectedIndexDelegate: ChangeSelectedIndexDelegate?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewModel.action.onNext(.viewWillLayoutSubviews)
    }
    
    // MARK: - Bind Helper
    
    override func bindViewModel() {
        // ViewModel ➡️ State
        // 사용자 위치로 카메라 이동
        viewModel.state.userLocation
            .compactMap { $0 }
            .bind(with: self) { owner, coordinates in
                let mapView = owner.mapTabView.getNaverMapView().mapView
                if mapView.positionMode == .disabled {
                    mapView.positionMode = .normal
                    owner.mapPositionMode = .direction
                }
                
                if owner.mapPositionMode == .direction {
                    owner.moveMapCamera(to: coordinates)
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
                guard let nearest = location.first else { return }
                owner.address = owner.makeAddress(location: nearest)
                owner.mapTabView.getSearchBar().text = owner.address
            }.disposed(by: disposeBag)
        
        
        // Action ➡️ ViewModel
        // 현재 위치 버튼 탭
        mapTabView.getLocationButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.mapPositionMode = .direction
                owner.viewModel.action.onNext(.didLocationButtonTap)
            }.disposed(by: disposeBag)
        
        // 장소 검색창 텍스트 전달
        mapTabView.getSearchBar().rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, text in
                owner.viewModel.action.onNext(.searchText(text: text))
            }.disposed(by: disposeBag)
        
        // 바인딩 완료 알림
        viewModel.action.onNext(.didBinding)
        
        Observable
            .combineLatest(viewModel.state.kickboardRide, viewModel.state.user)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] kickboard, user in
                self?.showCustomAlert(user: user, kickboard: kickboard)
            }
            .disposed(by: disposeBag)
        
        // 3. 에러 핸들링
        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind { error in
                print("오류 발생: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        
        // View ➡️ ViewController
        
        // 검색 결과 탭
        mapTabView.getSearchResultTableView().rx
            .modelSelected(LocationModel.self)
            .bind(with: self) { owner, location in
                // 지도 카메라 이동
                owner.mapPositionMode = .normal
                owner.mapTabView.getSearchBar().text = location.title
                owner.moveMapCamera(to: location.coordinates)
                owner.dismissKeyboard()
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 뒤로가기 버튼 탭
        mapTabView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.changeSelectedIndexDelegate?.changeSelectedIndexToPrevious()
                owner.isRegister = false
            }.disposed(by: disposeBag)
        
        // 킥보드 위치 등록 화면) 등록 버튼 탭
        mapTabView.getNavigationBarView().getRightButton().rx.tap
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                // 킥보드 등록
                let lat = owner.cameraCoordinates.lat
                let lng = owner.cameraCoordinates.lng
                let item: RegisterUIModel = .init(latitude: lat, longitude: lng, address: owner.address)
                
                let repository = CreateKickboardRepository()
                let useCaseInterface = CreateKickboardUseCase(repository: repository)
                let viewModel = RegisterViewModel(createKickboardUseCaseInterface: useCaseInterface)
                let registerVC = RegisterViewController(viewModel: viewModel, registerUIModel: item)
                owner.navigationController?.pushViewController(registerVC, animated: true)
            }.disposed(by: disposeBag)
        
        // 킥보드 마커 숨김 버튼 탭
        mapTabView.getHideKickboardButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleMarkerHideState()
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
        
        
        mapTabView.getCustomButton().rx.tap
            .bind(with: self) { owner, _ in
                if owner.mapTabView.getCustomButton().titleLabel?.text == "대여하기" {
                    // 킥보드 대여
                    guard let selectedKickboard = owner.selectedKickboard else { return }
                    
                    owner.viewModel.action.onNext(.didRentButtonTap(id: selectedKickboard.id,
                                                                    latitude: selectedKickboard.latitude,
                                                                    longitude: selectedKickboard.longitude,
                                                                    address: selectedKickboard.address))
                    
                    owner.isUsingKickboard = true
                    
                    owner.mapTabView.getCustomButton().configure(buttonTitle: "반납하기")
                    owner.elapsedMinutes = 0
                    owner.timer?.invalidate()
                    owner.timer = Timer.scheduledTimer(timeInterval: 60.0,
                                                 target: owner,
                                                 selector: #selector(owner.updateTimer),
                                                 userInfo: nil,
                                                 repeats: true)
                    owner.mapTabView.updateUsingKickboardViewTimeLabel(elapsedMinutes: owner.elapsedMinutes)
                } else {
                    owner.isUsingKickboard = false
                    // MARK: - 킥보드 반납 버튼 상태
                    owner.viewModel.action.onNext(.requestReturn)
                    
                    owner.mapTabView.getCustomButton().configure(buttonTitle: "대여하기")
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

@objc private extension MapTabViewController {
    func updateTimer() {
        elapsedMinutes += 1
        mapTabView.updateUsingKickboardViewTimeLabel(elapsedMinutes: elapsedMinutes)
    }
}

// MARK: - Private Methods

private extension MapTabViewController {
    /// coordinates 위치로 카메라 이동
    func moveMapCamera(to coordinates: CLLocationCoordinate2D) {
        let nmgCoordinate = NMGLatLng(from: coordinates)
        let cameraUpdate = NMFCameraUpdate(scrollTo: nmgCoordinate, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        
        let mapView = mapTabView.getNaverMapView().mapView
        DispatchQueue.main.async {
            mapView.moveCamera(cameraUpdate)
        }
    }
    
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
                "longtitude": $0.longitude,
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
            
            
            // 마커 눌렀을 때 핸들러
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self else { return true }
                
                self.tabBarController?.tabBar.isHidden = true
                self.mapTabView.getModalLikeContainerView().isHidden = false
                DispatchQueue.main.async {
                    self.mapTabView.showModalUpAnimation()
                }
                
                let id = overlay.userInfo["id"] as! UUID
                let latitude = overlay.userInfo["latitude"] as! Double
                let longtitude = overlay.userInfo["longtitude"] as! Double
                let battery = overlay.userInfo["battery"] as! Int
                let status = overlay.userInfo["status"] as! String
                
                selectedKickboard = Kickboard(id: id,
                                              latitude: latitude,
                                              longitude: longtitude,
                                              battery: battery,
                                              address: address,
                                              status: status)
                
                let usingKickboardView = self.mapTabView.getMapUsingKickboardView()
                let customButton = self.mapTabView.getCustomButton()
                
                switch battery {
                case 0...10:
                    usingKickboardView.batteryImageView.image = UIImage(systemName: "battery.0percent")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed)
                case 11...30:
                    usingKickboardView.batteryImageView.image = UIImage(systemName: "battery.25percent")
                case 31...65:
                    usingKickboardView.batteryImageView.image = UIImage(systemName: "battery.50percent")
                case 66...90:
                    usingKickboardView.batteryImageView.image = UIImage(systemName: "battery.75percent")
                default:
                    usingKickboardView.batteryImageView.image = UIImage(systemName: "battery.100percent")
                }
                usingKickboardView.batteryLabel.text = "배터리 \(battery)%"
                
                usingKickboardView.do {
                    $0.usingTimeLabel.do {
                        let text: String
                        switch status {
                        case KickboardStatus.able.rawValue:
                            text = "사용가능"
                            customButton.backgroundColor = .core
                            customButton.isEnabled = true
                        case KickboardStatus.declared.rawValue:
                            text = "신고 접수 중"
                            customButton.backgroundColor = .placeholderText
                            customButton.isEnabled = false
                        case KickboardStatus.lowBattery.rawValue:
                            text = "배터리 부족"
                            customButton.backgroundColor = .placeholderText
                            customButton.isEnabled = false
                        default:  // IMPOSSIBILITY
                            text = "배터리 부족"
                            customButton.backgroundColor = .placeholderText
                            customButton.isEnabled = false
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
                return true
            }
            
            return marker
        }
        
        return markerList
    }
    
    /// 마커 숨김 상태 변경
    func toggleMarkerHideState() {
        isAllMarkerHidden.toggle()
        kickboardMarkerList
            .filter { $0.userInfo["status"] as! String != KickboardStatus.impossibility.rawValue }
            .forEach { $0.hidden = isAllMarkerHidden }
    }
    
    /// 키보드 내림
    func dismissKeyboard() {
        mapTabView.getSearchBar().resignFirstResponder()
    }
    
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
        
        if let buildingName = land?.addition0.value {
            // + 건물 이름
            address += " \(buildingName)"
        }
        
        return address
    }
    
    private func showCustomAlert(user: User, kickboard: KickboardRide) {
        let name = user.name ?? "이름 없음"
        self.returnMinutes = calculateElapsedMinutes(kickboard: kickboard, userId: user.id)
        self.returnPrice = (returnMinutes * 100) + 500
        self.returnBattery = kickboard.battery
        
        
        print(returnPrice)

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
    
    private func calculateElapsedMinutes(kickboard: KickboardRide, userId: UUID) -> Int {
        let startTime = kickboard.startTime
        let now = Date()
        let minutes = Calendar.current.dateComponents([.minute], from: startTime, to: now).minute ?? 0
        return minutes
    }
}

// MARK: - NMFMapViewCameraDelegate

extension MapTabViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print("cameraDidChangeByReason")
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라가 현위치를 추적하는 것을 멈춤
        if reason == NMFMapChangedByGesture {
            mapPositionMode = .normal
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let coordinates = mapView.cameraPosition.target
        cameraCoordinates = coordinates
        if isRegister {
            viewModel.action.onNext(.mapViewCameraIdle(lat: coordinates.lat, lng: coordinates.lng))
        }
    }
}

// MARK: - NMFMapViewTouchDelegate

extension MapTabViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        dismissKeyboard()
        if !isUsingKickboard {
            mapTabView.showModalDownAnimation()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

// TODO: 지도 뷰 켜졌을 때 탑승중인 킥보드 있는지 확인

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
                        /// 하기의 값에 위도, 경도, 주소를 순서로 넣으면 됩니다.
                        latitude: 37.1234,
                        longitude: 127.5678,
                        address: "서울특별시 종로구 세종대로 175"
                    )
                    let returnVC = ReturnViewController(viewModel: viewModel, returnUIModel: returnUIModel)
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
