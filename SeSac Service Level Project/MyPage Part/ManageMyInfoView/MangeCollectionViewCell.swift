//
//  MangeCollectionViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/25.
//

import UIKit
import SnapKit

final class ManageCollectionViewCell: UICollectionViewCell {
    
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
    
    func configureForeCellForItem(title: String, selected: Bool) {
        titleLabel.text = title
        if selected {
            backgroundColor = .brandGreen
            titleLabel.textColor = .white
            layer.borderColor = nil
        }else {
            backgroundColor = .white
            titleLabel.textColor = .black
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray3?.cgColor
        }
    }
    
    private func setUp() {
        addSubview(titleLabel)
        self.layer.cornerRadius = 10
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: FontNames.regular, size: 14)
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
