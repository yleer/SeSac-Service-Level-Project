//
//  MangeCollectionViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/25.
//

import UIKit
import SnapKit

class ManageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ManageCollectionViewCell"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(titleLabel)
        self.layer.cornerRadius = 10
        titleLabel.textAlignment = .center
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
}
