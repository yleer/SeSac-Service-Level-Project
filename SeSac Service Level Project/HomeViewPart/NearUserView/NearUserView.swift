//
//  NearUserView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/01.
//

import UIKit
import SnapKit

class NearUserView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUp() {
        addSubview(tableView)
        tableView.register(ManageMyInfoPersonalInfoCell.self, forCellReuseIdentifier: ManageMyInfoPersonalInfoCell.identifier)
        tableView.register(ManageMyInfoImageCell.self, forCellReuseIdentifier: ManageMyInfoImageCell.identifier)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
//            make.top.equalToSuperview().offset(16)
//            make.bottom.equalToSuperview().offset(-16)
            make.edges.equalToSuperview()
        }
    }
}
