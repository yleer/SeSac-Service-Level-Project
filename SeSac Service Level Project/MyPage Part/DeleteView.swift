//
//  DeleteView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit

class DeleteView: UIView {
    
    let title = UILabel()
    let subTitle = UILabel()
    
    let cancelButton = UIButton()
    let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpCosntraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        backgroundColor = .gray
        addSubview(title)
        addSubview(subTitle)
        
        addSubview(cancelButton)
        addSubview(deleteButton)
        
        title.text = "정말 탈퇴하시겠습니까?"
        subTitle.text = "탈퇴하시면 세싹프렌즈를 사용하실 수 없어요 ㅠ"
        
        title.textAlignment = .center
        subTitle.textAlignment = .center
        cancelButton.setTitle("취소", for: .normal)
        deleteButton.setTitle("확인", for: .normal)
    }
    
    private func setUpCosntraints() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(30)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(22)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(48)
            make.width.equalTo(152)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(8)
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            
            make.height.equalTo(48)
            make.width.equalTo(152)
        }
        
        
    }
    
}
