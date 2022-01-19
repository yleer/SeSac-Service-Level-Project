//
//  NickNameView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//


import UIKit
import SnapKit

class NickNameView: UIView {
    
    let titleLabel = UILabel()
    let nickNameTextFieldView = CommonTextFieldView()
    let toNextButon = InActiveButton()
    
    
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
        addSubview(titleLabel)
        addSubview(toNextButon)
        addSubview(nickNameTextFieldView)
        
        titleLabel.text = "닉네임을 입력해 주세요"
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        
        nickNameTextFieldView.textField.placeholder = "10자 이내로 입력"
        toNextButon.setTitle("다음", for: .normal)
        nickNameTextFieldView.textField.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        toNextButon.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(268)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(168)
            make.centerX.equalToSuperview()
        }
        
        nickNameTextFieldView.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.height.equalTo(48)
            make.width.equalTo(263)
            make.top.equalTo(titleLabel.snp.bottom).offset(97)
        }
        
        toNextButon.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(343)
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameTextFieldView.snp.bottom).offset(72)
        }
    }
}
