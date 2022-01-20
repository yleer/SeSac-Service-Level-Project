//
//  GenderSelectionView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit

class GenderSelectionView: UIView {
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
    let buttonsStackView = UIStackView()
    
    let maleButton = GenderCustomButtonView()
    let femaleButton = GenderCustomButtonView()
    
    
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
        
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(maleButton)
        buttonsStackView.addArrangedSubview(femaleButton)
        
        addSubview(toNextButton)
        backgroundColor = .white
        
        // text alignments
        titleLabel.textAlignment = .center
        infoLabel.textAlignment = .center
        
        
        titleLabel.text = "성별을 선택해 주세요"
        infoLabel.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        
        toNextButton.setTitle("다음", for: .normal)
        
        // Text Colors
        infoLabel.textColor = UIColor(named: "grayscalegray7")

        // Fonts
        titleLabel.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        infoLabel.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        
        
        buttonsStackView.spacing = 12
        buttonsStackView.distribution = .fillEqually
        
        maleButton.genderImage.image = UIImage(named: "man")
        femaleButton.genderImage.image = UIImage(named: "woman")
        maleButton.genderLabel.text = "남자"
        femaleButton.genderLabel.text = "여자"
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
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(32)
            make.width.equalTo(344)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        toNextButton.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(32)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
    }
    
}
