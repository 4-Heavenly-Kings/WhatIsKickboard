//
//  MyPageView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

//MARK: - MyPageView
final class MyPageView: BaseView {
    
    //MARK: - Components
    /// 포비의 인사 View (킥보드 이용 중 X)
    let pobyGreetingView = PobyGreetingView()
    /// 사용자 킥보드 이용 View
    let usingKickboardView = MyPageUsingKickboardView()
    /// 구분선
    let dividingLine = UIView()
    /// 이름 수정 ~ 로그아웃 StackView
    let myPageStackView = MyPageStackView()
    /// 기본요금, 분당요금 StackView
    let priceStackView = PriceStackView()
    /// 회원탈퇴 Button
    let withDrawalButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        self.backgroundColor = .systemBackground
        
        dividingLine.do {
            $0.backgroundColor = .black
        }
        
        withDrawalButton.do {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor: UIColor.gray,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.gray
            ]
            
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(NSAttributedString(string: "회원탈퇴", attributes: attributes))
            config.baseForegroundColor = .gray
            
            $0.configuration = config
            $0.contentHorizontalAlignment = .center
        }
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
    }
    
    func pobyGreetingLayout() {
        self.addSubviews(pobyGreetingView, dividingLine, myPageStackView, withDrawalButton)
        
        pobyGreetingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(1)
        }
        
        myPageStackView.snp.makeConstraints {
            $0.top.equalTo(dividingLine.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        withDrawalButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalToSuperview().offset(-105 - 16)
        }
    }
    
    func kickboardUsingLayout() {
        self.addSubviews(usingKickboardView, dividingLine, myPageStackView, withDrawalButton)
        
        usingKickboardView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(usingKickboardView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(1)
        }
        
        myPageStackView.snp.makeConstraints {
            $0.top.equalTo(dividingLine.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        withDrawalButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalToSuperview().offset(-105 - 16)
        }
    }
    
    func removeComponents() {
        pobyGreetingView.removeFromSuperview()
        usingKickboardView.removeFromSuperview()
        dividingLine.removeFromSuperview()
        myPageStackView.removeFromSuperview()
        withDrawalButton.removeFromSuperview()
    }
    
    /// 킥보드를 이용중이지 않을 때는 포비 인사 뷰를 보여줘야함
    func pobyGreetingConfigure(user: User) {
        // 포비 인사 뷰
        let attributedText = NSMutableAttributedString.makeAttributedString(
            text: "\(user.name!)님, 안녕하세요!",
            highlightedParts: [
                (user.name!, .core, UIFont.jalnan2(28)),
                ("님, 안녕하세요!", .black, UIFont.jalnan2(28))
            ]
        )
        pobyGreetingView.userNameGreetingLabel.attributedText = attributedText
    }
    
    /// 킥보드를 이용중일때는 킥보드 이용 뷰가 보여야함
    func kickboardUsingconfigure(user: User) {
        // 킥보드 이용 뷰
        let text = "\(user.name!)님!"
        let attributedText2 = NSMutableAttributedString.makeAttributedString(
            text: text,
            highlightedParts: [
                ("\(user.name!)", UIColor(hex: "#69C6D3"), UIFont.systemFont(ofSize: 30, weight: .bold)),
                ("님!", UIColor.black, UIFont.systemFont(ofSize: 30, weight: .regular))
            ]
        )
        
        usingKickboardView.userNameLabel.attributedText = attributedText2
        
        /// currentKickboardRideId을 강제 옵셔널로 가져오고 있지만
        /// 킥보드 이용중이라면 킥보드 id 값이 무조건 있음
        KickboardPersistenceManager.getKickboardRide(id: user.currentKickboardRideId!)
            .subscribe(with: self, onSuccess: { owner, kickboardRide in
                let minutes = Calendar.current.dateComponents([.minute], from: kickboardRide.startTime, to: Date()).minute ?? 0
                
                let text = "\(minutes)분 이용 중"
                let attributedText = NSMutableAttributedString.makeAttributedString(
                    text: text,
                    highlightedParts: [
                        ("\(minutes)분", .black, UIFont.systemFont(ofSize: 30, weight: .bold)),
                        ("이용 중", .black, UIFont.systemFont(ofSize: 30, weight: .regular))
                    ]
                )
                owner.usingKickboardView.usingTimeLabel.attributedText = attributedText

                owner.usingKickboardView.batteryLabel.text = "배터리 \(kickboardRide.battery)%"
            }, onFailure: { owner, error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
