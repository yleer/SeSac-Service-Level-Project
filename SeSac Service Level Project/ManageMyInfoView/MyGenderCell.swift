//
//  MyGenderCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import SnapKit

class MyGenderCell: UITableViewCell {
    
    static let identifier = "MyGenderCell"
    
    let settingTitle = UILabel()
    let stackView = UIStackView()
    let maleButton = InActiveButton()
    let femaleButton = InActiveButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpStackView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(settingTitle)
        addSubview(stackView)
        
        settingTitle.text = "내 성별"
        
        stackView.addArrangedSubview(maleButton)
        stackView.addArrangedSubview(femaleButton)
    }
    
    private func setUpStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        maleButton.setTitle("남자", for: .normal)
        maleButton.setTitle("여자", for: .normal)
    }
    
    private func setUpConstraints() {
        settingTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
    }
    
    
    
    
}
