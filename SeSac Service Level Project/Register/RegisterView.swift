//
//  RegisterView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/17.
//

import UIKit
import SnapKit

class RegisterView: UIView {

    let instructionLabel = UILabel()
    let phoneNumberView = CommonTextFieldView()
    let getVerificationCodeButton = InActiveButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUp() {
        addSubview(instructionLabel)
        addSubview(getVerificationCodeButton)
        addSubview(phoneNumberView)
        
        instructionLabel.backgroundColor = .white
        instructionLabel.textColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        paragraphStyle.alignment = .center

        
        let attributedText = NSMutableAttributedString(
            string: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요",
            attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        instructionLabel.attributedText = attributedText
        
        
        getVerificationCodeButton.setTitle("인증 문자 받기", for: .normal)
        phoneNumberView.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        
        
        // Fonts
        phoneNumberView.textField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        getVerificationCodeButton.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    
    func setUpConstraints() {
        instructionLabel.snp.makeConstraints { make in
            make.width.equalTo(228)
            make.height.equalTo(64)
            make.top.equalToSuperview().offset(169)
            make.centerX.equalToSuperview()
        }

        phoneNumberView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(64)
            make.width.equalTo(343)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        
        getVerificationCodeButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberView.snp.bottom).offset(72)
            make.width.equalTo(343)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}
