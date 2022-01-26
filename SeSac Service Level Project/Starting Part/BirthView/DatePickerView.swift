//
//  DatePickerView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import SnapKit

class DatePickerView: UIView {
    
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(datePicker)
        backgroundColor = UIColor(red: 207 / 255, green: 209 / 255, blue: 217 / 255, alpha: 1)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
    }
    
    func setUpConstraints() {
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
