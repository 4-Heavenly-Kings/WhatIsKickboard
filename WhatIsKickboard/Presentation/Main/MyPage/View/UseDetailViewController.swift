//
//  UseDetailViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

import SnapKit
import Then

//MARK: - UseDetailViewController
final class UseDetailViewController: BaseViewController {
    
    // MARK: - Compoenets
    let useDetailTableView = UITableView()
    
    // MARK: - Properties
    let dummyData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func setStyles() {
        super.setStyles()
        
        useDetailTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UseDetailTableViewCell.self, forCellReuseIdentifier: UseDetailTableViewCell.className)
        }
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        view.addSubview(useDetailTableView)
        
        useDetailTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
