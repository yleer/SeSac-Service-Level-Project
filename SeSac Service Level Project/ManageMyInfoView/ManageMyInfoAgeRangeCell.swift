//
//  ManageMyInfoAgeRangeCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/25.
//

import UIKit
import SnapKit
import RangeSeekSlider

class ManageMyInfoAgeRangeCell: UITableViewCell {
    
    static let identifier = "ManageMyInfoAgeRangeCell"
    
    let settingTitle = UILabel()
    let selectedAgeRangeLabel = UILabel()
    let rangeSeeker = RangeSeekSlider()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstarints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        contentView.addSubview(settingTitle)
        contentView.addSubview(selectedAgeRangeLabel)
        contentView.addSubview(rangeSeeker)
        
        settingTitle.text = "상대방 연령대"
        selectedAgeRangeLabel.text = "15-35"
    }
    
    func setUpConstarints() {
        
        settingTitle.snp.makeConstraints { make in
            make.centerY.equalTo(34)
            make.leading.equalToSuperview()
        }
        
        selectedAgeRangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(34)
            make.trailing.equalToSuperview()
        }
        
        rangeSeeker.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
        }
        
    }
}
