//
//  BirthView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import SnapKit

class BirthView: UIView {
    
    let titleLabel = UILabel()

    let birthLabelView = BirthDateView()
    
    let toNextButon = InActiveButton()
    let datePickerView = DatePickerView()

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
        addSubview(birthLabelView)
        addSubview(toNextButon)
        addSubview(datePickerView)
        
        
        birthLabelView.yearLabel.text = "년"
        birthLabelView.dayLabel.text = "일"
        birthLabelView.monthLabel.text = "월"
        
        birthLabelView.bornYearLabel.text = "2021"
        birthLabelView.borndayLabel.text = "20"
        birthLabelView.bornMonthLabel.text = "08"

        titleLabel.text = "생년월일을 알려주세요"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        toNextButon.setTitle("다음", for: .normal)
        
    }
    
    func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(168)
            make.leading.equalToSuperview().offset(95)
            make.trailing.equalToSuperview().offset(-95)
            make.height.equalTo(32)
        }
        
        
        
        birthLabelView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        toNextButon.snp.makeConstraints { make in
            make.top.equalTo(birthLabelView.snp.bottom).offset(72)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        datePickerView.snp.makeConstraints { make in
            make.height.equalTo(216)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
    }
    
    
    
}
