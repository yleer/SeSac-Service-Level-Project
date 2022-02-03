//
//  SizingCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/27.
//

import SnapKit
import UIKit


enum SizingCellType {
    case nearBySpecial
    case defaultType
    case myHobby
}

class SizingCell: UICollectionViewCell {
    
    static let identifier = "SizingCell"
    
    let hobbyLabel = UILabel()
    let deleteButton = UIButton()
    var cellType = SizingCellType.defaultType{
        didSet {
            switch cellType {
            case .nearBySpecial:
                self.layer.borderColor = UIColor.errorRed?.cgColor
                hobbyLabel.textColor = .errorRed
                setUpForNormalConstraints()
            case .defaultType:
                self.layer.borderColor = UIColor.gray5?.cgColor
                hobbyLabel.textColor = .black
                setUpForNormalConstraints()
            case .myHobby:
                self.layer.borderColor = UIColor.brandGreen?.cgColor
                hobbyLabel.textColor = .brandGreen
                setUpConstraints()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        contentView.addSubview(hobbyLabel)
        contentView.addSubview(deleteButton)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray6?.cgColor
        self.layer.borderWidth = 1
        
        cellType = .defaultType
        hobbyLabel.font = UIFont(name: FontNames.regular, size: 14)
        deleteButton.setImage(UIImage(named: ImageNames.HobbySearchController.close_small), for: .normal)
    }
    
    func setUpConstraints() {
        hobbyLabel.snp.removeConstraints()
        deleteButton.snp.removeConstraints()
        hobbyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(32)
        }
        deleteButton.isHidden = false
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(hobbyLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(10.5)
        }
    }
    
    func setUpForNormalConstraints() {
        hobbyLabel.snp.removeConstraints()
        deleteButton.snp.removeConstraints()
        deleteButton.isHidden = true
        hobbyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(32)
        }
    }
}
