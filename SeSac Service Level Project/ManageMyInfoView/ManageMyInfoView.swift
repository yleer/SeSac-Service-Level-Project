//
//  ManageMyInfoView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit

class ManageMyInfoView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        backgroundColor = .white
        addSubview(tableView)
        
        tableView.register(ManageMyInfoPersonalInfoCell.self, forCellReuseIdentifier: ManageMyInfoPersonalInfoCell.identifier)
        tableView.register(ManageMyInfoImageCell.self, forCellReuseIdentifier: ManageMyInfoImageCell.identifier)
        tableView.register(MyGenderCell.self, forCellReuseIdentifier: MyGenderCell.identifier)
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
}
