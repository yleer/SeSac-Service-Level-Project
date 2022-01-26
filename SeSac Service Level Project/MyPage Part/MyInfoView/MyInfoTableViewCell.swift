//
//  MyInfoTableViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import SnapKit

class MyInfoTableViewCell: UITableViewCell {
    
    static let identifier = "MyInfoTableViewCell"
    
    private let profileImage = UIImageView()
    private let nameLabel = UILabel()
    private let moreImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFromCellForRowAt(image: UIImage, text: String) {
        profileImage.image = image
        nameLabel.text = text
    }
    
    private func setUp() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(moreImage)
        
        profileImage.layer.cornerRadius = 25
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.borderWidth = 1
        
        moreImage.image = UIImage(named: ImageNames.MyInfoTableViewCell.myInfoTableViewCellMore)
    }
    
    private func setUpConstraints() {
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(13)
            make.centerY.equalTo(profileImage.snp.centerY)
            make.trailing.equalTo(moreImage.snp.leading).offset(-8)
        }
        
        moreImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(9)
            make.height.equalTo(18)
        }
    }
}


