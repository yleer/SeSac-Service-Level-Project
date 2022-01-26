//
//  ManageMyInfoPersonalInfoCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//


// https://hururuek-chapchap.tistory.com/165


import UIKit
import SnapKit

class ManageMyInfoPersonalInfoCell: UITableViewCell {
    
    static let identifier = "ManageMyInfoPersonalInfoCell"

    var full = false {
        didSet{
            if full {
                subTitle.isHidden = false
                colletionView.isHidden = false
                sesacReviewLabel.isHidden = false
                waitingForeReiview.isHidden = false
                
                setUpConstraintsWhenFull()
            }else {
                subTitle.isHidden = true
                colletionView.isHidden = true
                sesacReviewLabel.isHidden = true
                waitingForeReiview.isHidden = true
                
                setUpConstraintsWhenFolded()
            }
        }
    }
    
//    func configureFromCellForRowAt<T: UICollectionViewDelegate>(vc: T) {
//        colletionView.delegate = T
//        colletionView.dataSource = T
//    }
    
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraintsWhenFolded()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setUp() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(subTitle)
        contentView.addSubview(colletionView)
        contentView.addSubview(sesacReviewLabel)
        contentView.addSubview(waitingForeReiview)
        
        
        colletionView.register(ManageCollectionViewCell.self, forCellWithReuseIdentifier: ManageCollectionViewCell.identifier)

        subTitle.text = "새싹 타이틀"
        nameLabel.text = "ASDF"
        sesacReviewLabel.text = "새싹 리뷰"
        moreButton.setImage(UIImage(named: ImageNames.ManageTableViewCell.manageTableViewCellMore), for: .normal)
        waitingForeReiview.text = "첫 리뷰를 기다리는 중"
    }
    
    private func setUpConstraintsWhenFolded() {
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        subTitle.snp.removeConstraints()
        colletionView.snp.removeConstraints()
        sesacReviewLabel.snp.removeConstraints()
        waitingForeReiview.snp.removeConstraints()
        
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
}
