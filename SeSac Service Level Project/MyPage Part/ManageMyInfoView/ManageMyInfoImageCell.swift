//
//  ManageMyInfoImageCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import SnapKit

enum ImageCellType {
    case noButton
    case requestButton
    case confirmButton
}

class ManageMyInfoImageCell: UITableViewCell {
    
    
    static let identifier = "ManageMyInfoImageCell"
    var cellType = ImageCellType.noButton
    
    let button = InActiveButton()
    let profileImage = UIImageView()
    let sesacImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
        
        checkButtonState()
    }
    
    func checkButtonState() {
        switch cellType {
        case .noButton:
            button.isHidden = true
        case .requestButton:
            button.isHidden = false
            button.stateOfButton = .redButton
        case .confirmButton:
            button.isHidden = false
            button.stateOfButton = .blueButton
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        contentView.addSubview(profileImage)
        contentView.addSubview(sesacImage)
        contentView.addSubview(button)

        profileImage.image = UIImage(named: ImageNames.ManageTableViewImageCell.profileImage)
        sesacImage.image = UIImage(named: ImageNames.ManageTableViewImageCell.sessacImage)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
    }
    
    func setUpConstraints() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            
            make.height.equalTo(profileImage.snp.height)
            make.width.equalTo(sesacImage.snp.height)
            
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
        }
    }
    
}
