//
//  CommonTextFieldView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/18.
//


import UIKit
import SnapKit

enum TextFieldState{
    case inActive
    case focus
    case active
    case disable
    case error(text: String)
    case success(text: String)
}


class CommonTextFieldView: UIView {
    
    let textField = UITextField()
    let focusLine = UIView()
    let infoLabel = UILabel()
    
    var stateOfTextField: TextFieldState = .inActive {
        didSet {
            switch stateOfTextField {
            case .inActive:
                focusLine.backgroundColor = UIColor(named: "grayscalegray3")
                textField.textColor = UIColor(named: "grayscalegray7")
                infoLabel.text = ""
            case .focus:
                focusLine.backgroundColor = UIColor(named: "systemfocus")
                textField.textColor = .black
                infoLabel.text = ""
            case .active:
                focusLine.backgroundColor = UIColor(named: "grayscalegray3")
                textField.textColor = .black
                infoLabel.text = ""
            case .disable:
                backgroundColor = UIColor(named: "grayscalegray3")
                textField.textColor = UIColor(named: "grayscalegray7")
                infoLabel.text = ""
            case .error(let text):
                focusLine.backgroundColor = UIColor(named: "systemerror")
                textField.textColor = .black
                infoLabel.textColor = UIColor(named: "systemerror")
                infoLabel.text = text
            case .success(let text):
                focusLine.backgroundColor = UIColor(named: "systemsuccess")
                textField.textColor = .black
                infoLabel.textColor = UIColor(named: "systemsuccess")
                infoLabel.text = text
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(textField)
        addSubview(focusLine)
        addSubview(infoLabel)
        
        textField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        stateOfTextField = .inActive
    }
    
    func setUpConstraints() {
        textField.snp.makeConstraints { make in
//            make.width.equalTo(343)
            make.width.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        focusLine.snp.makeConstraints { make in
//            make.width.equalTo(343)
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
//            make.width.equalTo(343)
            make.width.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
    }
    
}
