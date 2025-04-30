//
//  MyRegisterKickboardView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import SnapKit
import Then

// MARK: - MyRegisterKickboardView
final class MyRegisterKickboardView: BaseView {
    
    // MARK: - Compoenets
    /// 상단 status bar를 덮을 View
    private let statusBarBackgroundView = UIView()
    /// 상단 dock bar를 덮을 View
    private let dockBarBackgroundView = UIView()
    /// 이용내역  TableView
    private let myRegisterTableView = UITableView()
    /// 네비게이션 바
    private let navigationBarView = CustomNavigationBarView()
    
    //MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
        dockBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
        myRegisterTableView.do {
            $0.register(MyRegisterKickboardTableViewCell.self, forCellReuseIdentifier: MyRegisterKickboardTableViewCell.className)
        }
        
        navigationBarView.do {
            $0.configure(title: "킥보드 등록 내역", showsRightButton: false, rightButtonTitle: nil)
        }
        
    }
    
    //MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(statusBarBackgroundView, navigationBarView, myRegisterTableView, dockBarBackgroundView)
        
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        myRegisterTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        dockBarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(myRegisterTableView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func getMyRegisterTableView() -> UITableView {
        return myRegisterTableView
    }
    
    func getNavigationBarView() -> CustomNavigationBarView {
        return navigationBarView
    }
}
