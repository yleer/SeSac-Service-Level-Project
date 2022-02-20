//
//  SesacCollectionViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit

final class SesacCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SesacCollectionViewCell"
    
    let sesacImage = UIImageView()
    let tilte = UILabel()
    let price = InActiveButton()
    let subTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(sesacImage)
        addSubview(tilte)
        addSubview(price)
        addSubview(subTitle)
        subTitle.numberOfLines = 0
        
        sesacImage.layer.borderWidth = 1
        sesacImage.layer.borderColor = UIColor.gray3?.cgColor
        sesacImage.layer.cornerRadius = 20
        
        tilte.font = UIFont(name: FontNames.regular, size: 16)
        subTitle.font = UIFont(name: FontNames.regular, size: 14)
        
        
    }
    
    // 165 279
    private func setUpConstraints() {
        sesacImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(180).priority(750)
        }
        
        tilte.snp.makeConstraints { make in
            make.top.equalTo(sesacImage.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(26)
            make.trailing.equalTo(price.snp.leading).offset(-8)
        }
        
        price.snp.makeConstraints { make in
            make.centerY.equalTo(tilte)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(tilte.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(72)
            
        }
    }
    
}
