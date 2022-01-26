//
//  MyInfoSettingCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//


import UIKit
import SnapKit

final class MyInfoSettingCell: UITableViewCell {
    
    static let identifier = "MyInfoSettingCell"
    
    private let settingImage = UIImageView()
    private let settingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFromCellForRowAt(image: UIImage, text: String) {
        settingImage.image = image
        settingLabel.text = text
    }
    
    private func setUp() {
        addSubview(settingImage)
        addSubview(settingLabel)
    }
    
    private func setUpConstraints() {
        
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
