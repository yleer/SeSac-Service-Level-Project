//
//  BirthDateView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import SnapKit

class BirthDateView: UIView {
    
    let bornYearLabel = UILabel()
    let yearLabel = UILabel()
    
    let bornMonthLabel = UILabel()
    let monthLabel = UILabel()
    
    let borndayLabel = UILabel()
    let dayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUp() {
        addSubview(bornYearLabel)
        addSubview(yearLabel)
        
        addSubview(bornMonthLabel)
        addSubview(monthLabel)

        addSubview(borndayLabel)
        addSubview(dayLabel)
        
    }
    
    func setUpConstraints() {
        
        bornYearLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
            
            make.leading.equalToSuperview().offset(12)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
            make.leading.equalToSuperview().offset(84)
        }
        
        bornMonthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
            make.leading.equalTo(yearLabel.snp.trailing).offset(35)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
            make.leading.equalTo(yearLabel.snp.trailing).offset(107)
        }
        
        borndayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
            make.leading.equalTo(yearLabel.snp.trailing).offset(157)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
            make.leading.equalTo(yearLabel.snp.trailing).offset(229)
            make.trailing.equalToSuperview()
        }
    }
    
}
