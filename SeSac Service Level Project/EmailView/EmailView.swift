//
//  EmailView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import SnapKit

class EmailView: UIView {
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let emailTextFieldView = CommonTextFieldView()
    let toNextButton = InActiveButton()
    

    
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
        addSubview(emailTextFieldView)
        addSubview(toNextButton)
        backgroundColor = .white
        
        // text alignments
        titleLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        
        
        // Set texts
        emailTextFieldView.textField.placeholder = "사용할 이메일 주소를 입력해주세요"
        toNextButton.setTitle("다음", for: .normal)
        titleLabel.text = "이메일을 입력해 주세요"
        infoLabel.text = "휴대폰 번호 번경시 인증을 위해 사용해요"
        
        // Text Colors
        infoLabel.textColor = UIColor(named: "grayscalegray7")

        // Fonts
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        infoLabel.font = UIFont(name: "NotoSansKR-Medium", size: 16)
    }
    
    func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(268)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(168)
            make.centerX.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(26)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(97)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
 
        toNextButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(72)
        }
        
    }
    
    
}
