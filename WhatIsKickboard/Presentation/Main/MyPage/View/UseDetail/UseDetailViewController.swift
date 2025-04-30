//
//  UseDetailViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

//MARK: - UseDetailViewController
final class UseDetailViewController: BaseViewController {
    
    // MARK: - Compoenets
    let useDetailView = UseDetailView()
    
    // MARK: - Properties
    let dummyData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    // MARK: - View Life Cycels
    override func loadView() {
        super.loadView()
        
        view = useDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        useDetailView.getUseDetailTableView().delegate = self
        useDetailView.getUseDetailTableView().dataSource = self
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        useDetailView.getNavigationBarView().getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension UseDetailViewController: UITableViewDelegate {
    
}

extension UseDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UseDetailTableViewCell.className, for: indexPath)
        return cell
    }
}
