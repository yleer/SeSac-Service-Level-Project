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
        profileImage.image = UIImage(named: ImageNames.ManageTableViewImageCell.profileImage)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
    }
    
    func setUpConstraints() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
