//
//  GenderCustomButtonView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import SnapKit

class GenderCustomButtonView: UIView {
    
    let genderImage = UIImageView()
    let genderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(genderImage)
        addSubview(genderLabel)
        
        genderLabel.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "grayscalegray3")?.cgColor
    }
    
    func setUpConstraints() {
        genderImage.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(26)
            make.top.equalTo(genderImage.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
}
