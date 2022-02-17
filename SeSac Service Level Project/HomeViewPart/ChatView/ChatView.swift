//
//  ChatView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/10.
//

import UIKit
import SnapKit

class ChatView: UIView {
    
    let tableView = UITableView()
    let moreView = UIView()
    
    let stack = UIStackView()
    
    let reportButton = UIButton()
    let cancelButton = UIButton()
    let reviewButton = UIButton()
    let grayView = UIView()
    let chatTextView = UITextView()
    let sendButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    var amountOfLinesToBeShown: CGFloat = 3
    lazy var maxHeight: CGFloat = chatTextView.font?.lineHeight ?? 4 * amountOfLinesToBeShown
    
    func fitTextViewSize(bottom: CGFloat, up: Bool) {

        let a = chatTextView.sizeThatFits(CGSize(width: chatTextView.frame.size.width, height: maxHeight))
        chatTextView.snp.removeConstraints()
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(a.height)
            make.centerX.equalToSuperview()
            
            if up {
                make.bottom.equalToSuperview().offset(-bottom - 16)
            }else {
                make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            }
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(chatTextView)
            make.size.equalTo(20)
            make.trailing.equalToSuperview().offset(-14)
        }
    }
    
    func setUp() {
        backgroundColor = .white
        addSubview(tableView)
        addSubview(moreView)
        addSubview(chatTextView)
        
        addSubview(grayView)
        addSubview(sendButton)
        
        sendButton.setImage(UIImage(named: ImageNames.ChatViewController.sendGray), for: .normal)
        
        grayView.backgroundColor = .gray
        
        moreView.addSubview(stack)
//        stack.isHidden = true
        moreView.isHidden = true
        stack.addArrangedSubview(reportButton)
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(reviewButton)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
         
        reportButton.setImage(UIImage(named:ImageNames.ChatViewController.siren), for: .normal)
        reportButton.setTitle("새싹 신고", for: .normal)
        reportButton.setTitleColor(.black, for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        reviewButton.setTitleColor(.black, for: .normal)
        
        cancelButton.setImage(UIImage(named:ImageNames.ChatViewController.cancelMatch), for: .normal)
        cancelButton.setTitle("약속 취소", for: .normal)
        
        reviewButton.setImage(UIImage(named:ImageNames.ChatViewController.write), for: .normal)
        reviewButton.setTitle("리뷰 등록", for: .normal)
        chatTextView.font = UIFont(name: FontNames.regular, size: 14)

        reviewButton.imageEdgeInsets = .init(top: 0, left: 45, bottom: 25, right: 0)

        reviewButton.titleEdgeInsets = .init(top: 30, left: 10, bottom: 0, right: 40)

        cancelButton.imageEdgeInsets = .init(top: 0, left: 45, bottom: 25, right: 0)

        cancelButton.titleEdgeInsets = .init(top: 30, left: 10, bottom: 0, right: 40)
        
        reportButton.imageEdgeInsets = .init(top: 0, left: 45, bottom: 25, right: 0)

        reportButton.titleEdgeInsets = .init(top: 30, left: 10, bottom: 0, right: 40)
    
        
        cancelButton.titleLabel?.font = UIFont(name: FontNames.medium, size: 14)
        reportButton.titleLabel?.font = UIFont(name: FontNames.medium, size: 14)
        reviewButton.titleLabel?.font = UIFont(name: FontNames.medium, size: 14)
        reviewButton.backgroundColor = .white

        chatTextView.backgroundColor = .gray1
        tableView.backgroundColor = .white
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)

    }
    
    func setUpKeyBoardConstraints(keyBoardHeight: CGFloat) {
        tableView.snp.removeConstraints()
        chatTextView.snp.removeConstraints()
        sendButton.setImage(UIImage(named: ImageNames.ChatViewController.sendGreen), for: .normal)
        
        tableView.snp.makeConstraints { make in
//            make.edges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(safeAreaLayoutGuide).offset(-keyBoardHeight)
        }
        bringSubviewToFront(chatTextView)
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-keyBoardHeight)
            make.centerX.equalToSuperview()
        }
        fitTextViewSize(bottom:keyBoardHeight, up: true)
    }
   
    func setUpConstraints() {
        tableView.snp.removeConstraints()
        chatTextView.snp.removeConstraints()
        
        sendButton.setImage(UIImage(named: ImageNames.ChatViewController.sendGray), for: .normal)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(chatTextView.snp.top).offset(-16)
        }
        
        moreView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(72)
            make.width.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(moreView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(52)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        fitTextViewSize(bottom:1, up: true)
    }
}
