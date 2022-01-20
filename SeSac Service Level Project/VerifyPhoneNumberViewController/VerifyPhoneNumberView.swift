//
//  VerifyPhoneNumberView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import UIKit
import SnapKit

class VerifyPhoneNumberView: UIView {
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let verifyAndStartButton = InActiveButton()
    let verificationCodeView = CommonTextFieldView()
    let resendButton = InActiveButton()
    let timerLabel = UILabel()
    
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
        addSubview(infoLabel)
        addSubview(verifyAndStartButton)
        addSubview(verificationCodeView)
        addSubview(resendButton)
        verificationCodeView.addSubview(timerLabel)
        
        backgroundColor = .white
        resendButton.stateOfButton = .fill
        verificationCodeView.textField.keyboardType = .numberPad
        
        // text alignments
        titleLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        
        
        // Set texts
        verificationCodeView.textField.placeholder = "인증번호 입력"
        verifyAndStartButton.setTitle("인증하고 시작하기", for: .normal)
        resendButton.setTitle("재전송", for: .normal)
        titleLabel.text = "인증번호가 문자로 전송되었어요"
        infoLabel.text = "(최대 소모 30초)"
        timerLabel.text = "05:00"
        
        
        // Text Colors
        timerLabel.textColor = UIColor(named: "brand colorgreen")
        infoLabel.textColor = UIColor(named: "grayscalegray7")
        
        
        // Fonts
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        infoLabel.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        resendButton.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        timerLabel.font = UIFont(name: "NotoSansKR-Medium", size: 14)
    }
    
    func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(268)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(168)
            make.centerX.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(26)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        verificationCodeView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.height.equalTo(48)
            make.width.equalTo(263)
            make.top.equalTo(titleLabel.snp.bottom).offset(97)
        }
        
        resendButton.snp.makeConstraints { make in
            make.leading.equalTo(verificationCodeView.snp.trailing).offset(20)
            make.width.equalTo(72)
            make.height.equalTo(40)
            make.centerY.equalTo(verificationCodeView)
        }
        
        verifyAndStartButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
            make.top.equalTo(verificationCodeView.snp.bottom).offset(72)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(214)
        }
    }
}
