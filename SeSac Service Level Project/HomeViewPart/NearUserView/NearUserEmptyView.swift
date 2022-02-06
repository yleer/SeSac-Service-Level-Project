//
//  NearUserEmptyView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/05.
//

import UIKit
import SnapKit

class NearUserEmptyView: UIView {
    
    let centerImage = UIImageView()
    let title = UILabel()
    let subTitle = UILabel()
    let changeHobbyButton = InActiveButton()
    let refreshButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(centerImage)
        addSubview(title)
        addSubview(subTitle)
        addSubview(changeHobbyButton)
        addSubview(refreshButton)
        
        title.textAlignment = .center
        subTitle.textAlignment = .center
        centerImage.image = UIImage(named: ImageNames.NearByViewController.emptyLeaf)
        title.text = "아쉽게도 주변에 새싹이 없어요"
        subTitle.text = "취미를 변경하거나 조금만 더 기다려주세요!"
        
        changeHobbyButton.stateOfButton = .fill
        changeHobbyButton.setTitle("취미 변경하기", for: .normal)
        refreshButton.backgroundColor = .white
        refreshButton.setImage(UIImage(named: ImageNames.NearByViewController.refresh), for: .normal)
        refreshButton.layer.borderWidth = 1
        refreshButton.layer.cornerRadius = 15
        refreshButton.layer.borderColor = UIColor.brandGreen?.cgColor
        
    }
    
    func setUpConstraints() {
        centerImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(190)
            make.centerX.equalToSuperview()
            make.width.equalTo(64)
            make.height.equalTo(64)
        }
        title.snp.makeConstraints { make in
            make.top.equalTo(centerImage.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            
        }
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        
        changeHobbyButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-8)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(48)
            make.width.equalTo(48)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
}
