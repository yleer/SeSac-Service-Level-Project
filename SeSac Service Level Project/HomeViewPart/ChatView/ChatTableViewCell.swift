//
//  ChatTableViewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/14.
//

import UIKit
import SnapKit

enum ChatCellType {
    case myChat
    case opponentChat
}

final class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCell"
    
    let containerView = UIView()
    let chatLabel = UILabel()
    let timeLabel = UILabel()
    var chatType = ChatCellType.opponentChat {
        didSet{
            switch chatType {
            case .myChat:
                containerView.backgroundColor = UIColor(red: 205 / 255, green: 244 / 255, blue: 225 / 255, alpha: 1)
                chatLabel.textAlignment = .right
                setUpConstraints()
            case .opponentChat:
                containerView.layer.borderWidth = 1
                containerView.layer.borderColor = UIColor.gray4?.cgColor
                chatLabel.textAlignment = .left
                setUpConstraints()
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    private func setUp() {
        
        contentView.addSubview(containerView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(chatLabel)
        chatLabel.font = UIFont(name: FontNames.regular, size: 14)
        chatLabel.textColor = .black
        containerView.layer.cornerRadius = 10
        chatLabel.numberOfLines = 0
        timeLabel.text = "15:20"
        timeLabel.font = UIFont(name: FontNames.regular, size: 12)
        timeLabel.textColor = .gray6
    }
    
    private func setUpConstraints() {
        containerView.snp.removeConstraints()
        timeLabel.snp.removeConstraints()
        containerView.snp.makeConstraints { make in
            
            if chatType == .myChat {
                make.trailing.equalToSuperview().offset(-16)
            }else {
                make.leading.equalToSuperview().offset(16)
            }
            
            make.width.lessThanOrEqualTo(300)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            
        }
        
        chatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        timeLabel.snp.makeConstraints { make in
            if chatType == .myChat {
                make.trailing.equalTo(containerView.snp.leading).offset(-8)
            }else {
                make.leading.equalTo(containerView.snp.trailing).offset(8)
            }
            make.bottom.equalTo(containerView.snp.bottom)
            make.width.equalTo(30)
            make.height.equalTo(18)
        }
    }
    
}
