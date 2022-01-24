//
//  MyInfoSettingCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//


import UIKit
import SnapKit

class MyInfoSettingCell: UITableViewCell {
    
    let settingImage = UIImageView()
    let settingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        addSubview(settingImage)
        addSubview(settingLabel)
    }
    
    func setUpConstraints() {
        
        settingImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            
        }
        
        settingLabel.snp.makeConstraints { make in
            make.leading.equalTo(settingImage.snp.trailing).offset(14)
            make.centerY.equalTo(settingImage.snp.centerY)
            make.trailing.equalToSuperview().offset(-2)
            
        }
    }
}
