//
//  BackGroundTableViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit

final class BackGroundTableViewCell: UITableViewCell {
    
    static let identifier = "BackGroundTableViewCell"
    
    let backGroundImage = UIImageView()
    let title = UILabel()
    let subTitle = UILabel()
    let price = InActiveButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(backGroundImage)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        contentView.addSubview(price)
        
        backGroundImage.layer.cornerRadius = 15
        
        title.font = UIFont(name: FontNames.medium, size: 14)
        subTitle.font = UIFont(name: FontNames.regular, size: 14)
    
        price.backgroundColor = .gray2
        price.layer.cornerRadius = 15
        subTitle.numberOfLines = 0
    }
    
    // 342  165
    private func setUpConstraints() {
        
        backGroundImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(165)
            make.width.equalTo(165)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(43)
            make.leading.equalTo(backGroundImage.snp.trailing).offset(12)
            make.height.equalTo(22)
            make.trailing.equalTo(price.snp.leading).offset(-4)
        }
        
        price.snp.makeConstraints { make in
            make.centerY.equalTo(title)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalTo(backGroundImage.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(-40)
            make.trailing.equalToSuperview()
        }
        
    }
}
