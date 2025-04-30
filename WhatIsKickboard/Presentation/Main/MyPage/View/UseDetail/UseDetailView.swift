//
//  UseDetailView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import SnapKit
import Then

//MARK: - UseDetailView
final class UseDetailView: BaseView {
    
    // MARK: - Compoenets
    /// 상단 status bar를 덮을 View
    private let statusBarBackgroundView = UIView()
    /// 상단 dock bar를 덮을 View
    private let dockBarBackgroundView = UIView()
    /// 이용내역  TableView
    private let useDetailTableView = UITableView()
    /// 네비게이션 바 (마이페이지 전용)
    private let navigationBarView = CustomNavigationBarView()
    
    override func setStyles() {
        super.setStyles()
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
        dockBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
        useDetailTableView.do {
            $0.register(UseDetailTableViewCell.self, forCellReuseIdentifier: UseDetailTableViewCell.className)
        }
        
        navigationBarView.do {
            $0.configure(title: "이용 내역", showsRightButton: false, rightButtonTitle: nil)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(statusBarBackgroundView, navigationBarView, useDetailTableView, dockBarBackgroundView)
        
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        useDetailTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        dockBarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(useDetailTableView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func getUseDetailTableView() -> UITableView {
        return useDetailTableView
    }
    
    func getNavigationBarView() -> CustomNavigationBarView {
        return navigationBarView
    }
}
