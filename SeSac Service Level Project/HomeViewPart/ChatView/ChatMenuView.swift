//
//  ChatMenuView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/10.
//

import UIKit
import SnapKit

class ChatMenuView: UIView {
    
    let title = UILabel()
    let cancelButton = UIButton()
    let subTitle = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ManageCollectionViewCell.self, forCellWithReuseIdentifier: ManageCollectionViewCell.identifier)
        return cv
    }()
    
    let textView = UITextView()
    let confirmButton = InActiveButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUp()
//        setUpConstraintsForReport()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(title)
        addSubview(cancelButton)
        addSubview(subTitle)
        addSubview(collectionView)
        addSubview(textView)
        addSubview(confirmButton)
        
        
        title.font = UIFont(name: FontNames.medium, size: 14)
        
        subTitle.font = UIFont(name: FontNames.regular, size: 14)
        subTitle.textColor = .brandGreen
        
        textView.backgroundColor = .gray1
        
        cancelButton.setImage(UIImage(named: ImageNames.ChatViewController.closeBig), for: .normal)

    }
    
    func setUpConstraintsForReport() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(title)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(72)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(114)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
    func setUpConstraintsForReview() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(title)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(112)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(114)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
    }
}
