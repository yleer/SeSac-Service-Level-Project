//
//  BackgroundPurchaseVIew.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit


final class BackgroundPurchaseView: UIView {
    
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
        addSubview(tableView)
        tableView.register(BackGroundTableViewCell.self, forCellReuseIdentifier: BackGroundTableViewCell.identifier)
    }
    
    private func setUpConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().priority(750)
            make.trailing.equalToSuperview().offset(-16).priority(750)
        }
    }
}
