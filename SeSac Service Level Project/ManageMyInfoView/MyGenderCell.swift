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
    let textFieldView = UITextField()
    let phoneSwitch = UISwitch()
//    let textf = CommonTextFieldView()
    
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
        
        contentView.addSubview(stackView)
        contentView.addSubview(phoneSwitch)
        contentView.addSubview(textFieldView)
        textFieldView.textAlignment = .right
        
        
        settingTitle.text = "내 성별"
        textFieldView.placeholder = "취미를 입력해주세요"
        
        
        stackView.addArrangedSubview(maleButton)
        stackView.addArrangedSubview(femaleButton)
        
        stackView.isHidden = true
        phoneSwitch.isHidden = true
        textFieldView.isHidden = true
    }
    
    private func setUpStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        maleButton.setTitle("남자", for: .normal)
        femaleButton.setTitle("여자", for: .normal)
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
        
        phoneSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(165)
        }
    }
    
    
    
    
}
