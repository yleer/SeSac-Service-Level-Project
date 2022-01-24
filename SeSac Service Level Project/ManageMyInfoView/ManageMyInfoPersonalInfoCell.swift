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
    
    var full = false
    {
        didSet {
            if full {
                print("full")
                setUpConstraints()
                containerView.isHidden = false
            }else {
                print("not full")
                setUpWhenNotFull()
                containerView.isHidden = true
            }
            
        }
    }

    let nameLabel = UILabel()
    let moreButton = UIButton()
    
    let containerView = UIView()
    let subTitle = UILabel()
    
    let containerStack = UIStackView()
    let firstHoriznontalStack = UIStackView()
    let secondHorizontalStack = UIStackView()
    let thirdHorizontalStack = UIStackView()
    
    let goodMannerButton = UIButton()
    let rightTimeButton = UIButton()
    
    let quickResponse = UIButton()
    let nicePerson = UIButton()
    
    let goodHobby = UIButton()
    let goodTime = UIButton()
    
    let sesacReviewLabel = UILabel()
    let waitingForeReiview = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpWhenNotFull()
        setUpStack()
        setUpContainerViewConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpStack() {
        
        firstHoriznontalStack.addArrangedSubview(goodMannerButton)
        firstHoriznontalStack.addArrangedSubview(rightTimeButton)

        firstHoriznontalStack.distribution = .fillEqually
        firstHoriznontalStack.axis = .horizontal
        firstHoriznontalStack.spacing = 8
        firstHoriznontalStack.backgroundColor = .blue

        secondHorizontalStack.addArrangedSubview(quickResponse)
        secondHorizontalStack.addArrangedSubview(nicePerson)


        secondHorizontalStack.backgroundColor = .red
        secondHorizontalStack.distribution = .fillEqually
        secondHorizontalStack.axis = .horizontal
        secondHorizontalStack.spacing = 8

        thirdHorizontalStack.addArrangedSubview(goodHobby)
        thirdHorizontalStack.addArrangedSubview(goodTime)

        thirdHorizontalStack.distribution = .fillEqually
        thirdHorizontalStack.axis = .horizontal
        thirdHorizontalStack.spacing = 8

        containerStack.addArrangedSubview(firstHoriznontalStack)
        containerStack.addArrangedSubview(secondHorizontalStack)
        containerStack.addArrangedSubview(thirdHorizontalStack)

        containerStack.distribution = .fillEqually
        containerStack.axis = .vertical
        containerStack.spacing = 8
    }
    
    private func setUp() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(containerView)
        containerView.addSubview(containerStack)
        
//        setUpStack()
        containerView.addSubview(subTitle)
        containerView.addSubview(sesacReviewLabel)
        nameLabel.backgroundColor = .black
        containerView.addSubview(waitingForeReiview)
        subTitle.text = "새싹 타이틀"
        nameLabel.text = "ASDF"
        sesacReviewLabel.text = "새싹 리뷰"
        moreButton.setImage(UIImage(named: ImageNames.ManageTableViewCell.manageTableViewCellMore), for: .normal)
        waitingForeReiview.text = "첫 리뷰를 기다리는 중"
    }
    
    private func setUpConstraints() {
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        containerStack.snp.removeConstraints()

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(26)
        }

        moreButton.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(12)
            make.top.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().offset(-18)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(250)
//            make.bottom.equalToSuperview()
        }
    }
    private func setUpWhenNotFull() {
        nameLabel.snp.removeConstraints()
        moreButton.snp.removeConstraints()
        containerStack.snp.removeConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
//            make.height.equalTo(26)
        }
        
        moreButton.snp.makeConstraints { make in
            make.height.equalTo(6)
            make.width.equalTo(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-18)
        }
    }
    
    
    private func setUpContainerViewConstraints() {
        subTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(18)
        }

        containerStack.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(112)
        }
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.equalTo(containerStack.snp.bottom).offset(24)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
        waitingForeReiview.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(24)

        }
    }
}


// 예전에 view 만들 때 protocol 만들어서 setUp이랑 setUpConstraints 강제 시켰는데, 이렇게 프로토콜로 강제하는 의미가 무엇인가?

// 정보 관리텝 cell 높이. 절대값?

