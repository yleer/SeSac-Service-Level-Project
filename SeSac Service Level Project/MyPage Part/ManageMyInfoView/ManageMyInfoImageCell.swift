//
//  ManageMyInfoImageCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import SnapKit


class ManageMyInfoImageCell: UITableViewCell {
    
    
    static let identifier = "ManageMyInfoImageCell"
    
    let profileImage = UIImageView()
    let sesacImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(profileImage)
        addSubview(sesacImage)
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
    }
    
}
