//
//  MyRegisterKickboardViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

// MARK: - MyRegisterKickboardViewController
final class MyRegisterKickboardViewController: BaseViewController {
    
    // MARK: - Compoenets
    let myRegisterKickboardView = MyRegisterKickboardView()
    
    // MARK: - Properties
    let dummyData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func loadView() {
        super.loadView()
        
        view = myRegisterKickboardView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setStyles() {
        super.setStyles()
        
        myRegisterKickboardView.getMyRegisterTableView().delegate = self
        myRegisterKickboardView.getMyRegisterTableView().dataSource = self
        
    }
    
    override func setLayout() {
        super.setLayout()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        myRegisterKickboardView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension MyRegisterKickboardViewController: UITableViewDelegate {
    
}

extension MyRegisterKickboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRegisterKickboardTableViewCell.className, for: indexPath)
        return cell
    }
}
