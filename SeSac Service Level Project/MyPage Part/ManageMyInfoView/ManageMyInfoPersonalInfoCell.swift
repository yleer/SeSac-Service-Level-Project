//
//  ManageMyInfoPersonalInfoCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//


// https://hururuek-chapchap.tistory.com/165


import UIKit
import SnapKit

enum InfoCellType {
    case myInfo
    case hobby
}


class ManageMyInfoPersonalInfoCell: UITableViewCell {
    
    static let identifier = "ManageMyInfoPersonalInfoCell"
    
    var infoCellType = InfoCellType.myInfo

    var full = false {
        didSet{
            if full {
                subTitle.isHidden = false
                colletionView.isHidden = false
                wantHobbies.isHidden = false
                wantHobbyLabel.isHidden = false
                sesacReviewLabel.isHidden = false
                waitingForeReiview.isHidden = false
                moreButton.setImage(UIImage(named: ImageNames.ManageTableViewCell.manageTableVectortUp), for: .normal)
                
                switch infoCellType {
                case .myInfo:
                    setUpConstraintsWhenFull()
                case .hobby:
                    setUpIncludeingHobbiesFull()
//                    setUpConstraintsWhenFull()
                }
            }else {
                subTitle.isHidden = true
                colletionView.isHidden = true
                sesacReviewLabel.isHidden = true
                waitingForeReiview.isHidden = true
                wantHobbies.isHidden = true
                wantHobbyLabel.isHidden = true
                moreButton.setImage(UIImage(named: ImageNames.ManageTableViewCell.manageTableVectortDown), for: .normal)
                setUpConstraintsWhenFolded()
            }
        }
    }
    
    let nameLabel = UILabel()
    let moreButton = UIButton()
    let subTitle = UILabel()
    let colletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10

        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return cv
    }()
    
    let sesacReviewLabel = UILabel()
    let waitingForeReiview = UILabel()
    let moreButtonForReview = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraintsWhenFolded()
//        backgroundColor = .green
    }
    
    let wantHobbyLabel = UILabel()
    let wantHobbies : UICollectionView = {
        
        let layout = CollectionViewLeftAlignFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        cv.register(SizingCell.self, forCellWithReuseIdentifier: SizingCell.identifier)
        return cv
    }()
        
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    private func setUp() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray3?.cgColor
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(subTitle)
        contentView.addSubview(colletionView)
        contentView.addSubview(sesacReviewLabel)
        contentView.addSubview(waitingForeReiview)
        contentView.addSubview(wantHobbies)
        contentView.addSubview(wantHobbyLabel)
        contentView.addSubview(moreButtonForReview)
        
        
        moreButtonForReview.setImage(UIImage(named: "Vector 49"), for: .normal)
        colletionView.register(ManageCollectionViewCell.self, forCellWithReuseIdentifier: ManageCollectionViewCell.identifier)

        nameLabel.font = UIFont(name: FontNames.medium, size: 16)
        subTitle.font = UIFont(name: FontNames.regular, size: 12)
        subTitle.text = "새싹 타이틀"
        nameLabel.text = "ASDF"
        sesacReviewLabel.text = "새싹 리뷰"
        sesacReviewLabel.font = UIFont(name: FontNames.regular, size: 12)
        waitingForeReiview.font = UIFont(name: FontNames.regular, size: 14)
        waitingForeReiview.textColor = .gray4
        moreButton.setImage(UIImage(named: ImageNames.ManageTableViewCell.manageTableVectortDown), for: .normal)
        waitingForeReiview.text = "첫 리뷰를 기다리는 중"
        wantHobbyLabel.text = "하고 싶은 취미"
        wantHobbyLabel.font = UIFont(name: FontNames.regular, size: 14)
    }
    
    private func setUpConstraintsWhenFolded() {
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        subTitle.snp.removeConstraints()
        colletionView.snp.removeConstraints()
        sesacReviewLabel.snp.removeConstraints()
        waitingForeReiview.snp.removeConstraints()
        moreButtonForReview.snp.removeConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-18)
            make.width.equalTo(12)
            make.height.equalTo(6)
        }
    }
    
    private func setUpConstraintsWhenFull() {
        
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(32.5)
            make.leading.equalToSuperview().offset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(32.5)
            make.trailing.equalToSuperview().offset(-18)
            make.width.equalTo(12)
            make.height.equalTo(6)
        }

        subTitle.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        colletionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(112)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(colletionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        waitingForeReiview.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setUpIncludeingHobbiesFull() {
        
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(32.5)  
            make.leading.equalToSuperview().offset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(32.5)
            make.trailing.equalToSuperview().offset(-18)
            make.width.equalTo(12)
            make.height.equalTo(6)
        }

        subTitle.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        colletionView.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(112)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        wantHobbyLabel.snp.makeConstraints { make in
            make.top.equalTo(colletionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        wantHobbies.snp.makeConstraints { make in
            make.top.equalTo(wantHobbyLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(16)
            make.height.equalTo(32)
        }
        
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(wantHobbies.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        moreButtonForReview.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(6)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(sesacReviewLabel)
        }
        
        waitingForeReiview.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
