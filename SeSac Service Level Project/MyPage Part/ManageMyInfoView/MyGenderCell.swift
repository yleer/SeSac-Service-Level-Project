//
//  MyGenderCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import SnapKit

final class MyGenderCell: UITableViewCell {
    
    static let identifier = "MyGenderCell"
    
    private let settingTitle = UILabel()
    private let stackView = UIStackView()
    let maleButton = InActiveButton()
    let femaleButton = InActiveButton()
    let textFieldView = UITextField()
    let phoneSwitch = UISwitch()
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpStackView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func configureFromCellForRowAt(title: String, type: ManageCellType) {
        settingTitle.font = UIFont(name: FontNames.regular, size: 14)
        settingTitle.text = title
        
        stackView.isHidden = true
        phoneSwitch.isHidden = true
        textFieldView.isHidden = true
        deleteButton.isHidden = true
        
        switch type {
        case .gender:
            stackView.isHidden = false
        case .hobby(let hobby):
            textFieldView.isHidden = false
            textFieldView.text = hobby
        case .searchable:
            phoneSwitch.isHidden = false
        case .withdrawl:
            deleteButton.isHidden = false
        }
    }
    
    func genderButton(gender: Int) {
        if gender == 0 {
            femaleButton.backgroundColor = .brandGreen
            maleButton.backgroundColor = .white
        }else if gender == 1{
            maleButton.backgroundColor = .brandGreen
            femaleButton.backgroundColor = .white
        }else {
            maleButton.backgroundColor = .white
            femaleButton.backgroundColor = .white
        }
    }
    
    private func setUp() {
        addSubview(settingTitle)
        
        contentView.addSubview(stackView)
        contentView.addSubview(phoneSwitch)
        contentView.addSubview(textFieldView)
        contentView.addSubview(deleteButton)
        textFieldView.textAlignment = .right
        
        
        settingTitle.text = "??? ??????"
        textFieldView.placeholder = "????????? ??????????????????"
        
        
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
        
        maleButton.setTitle("??????", for: .normal)
        femaleButton.setTitle("??????", for: .normal)
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
        deleteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


enum ManageCellType {
    case gender
    case hobby(hobby: String)
    case searchable
    case withdrawl
}



