//
//  ChattingViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/29.
//

import UIKit
import Toast

class ChattingViewController: UIViewController {
    
    let mainView = ChatView()
    let viewModel = ChattingViewModel()
    var datas = ["hee","wow", "dsfgsdfg asdfas qweqwe dafs asdf asdf asdf qwe q qwe a vvadf qew", "s dhh", "asdf "]
    
    var keyboardHeight: CGFloat = 0
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCurrentState()
        viewModel.loadFromRealm()
        mainView.tableView.reloadData()
        
        // socket 연결
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: ImageNames.ChatViewController.more), style: .plain, target: self, action: #selector(showExtraButtonClicked))
        addTargets()
        
        mainView.chatTextView.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func checkCurrentState() {
        viewModel.myState { error, statusCode in
            if statusCode == 200 {
                if UserInfo.current.matched == 1 {
                    self.title = UserInfo.current.matchedNick
                }else {
                    return
                }
                if UserInfo.current.dodged == 1 || UserInfo.current.reviewed == 1 {
                    self.view.makeToast("약속이 종료되어 채팅을 보낼 수 없습니다")
                }else {
                 return
                }
            }
        }
    }
    
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.firstLoadData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell, let realmData = viewModel.firstLoadData else {
            print("not good")
            return UITableViewCell() }
        
        if indexPath.row % 2 == 0{
            cell.chatLabel.text = realmData[indexPath.row].message
            cell.chatType = .opponentChat
        }else {
            cell.chatType = .myChat
            cell.chatLabel.text = realmData[indexPath.row].message
        }
        return cell
    }
    
    
}


extension ChattingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mainView.fitTextViewSize(bottom: keyboardHeight, up: true)
    }
}





// ChattingViewController Menu AddTargets
extension ChattingViewController {
    func addTargets() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(sender:))))
        mainView.reportButton.addTarget(self, action: #selector(reportButtonClicked), for: .touchUpInside)
        mainView.cancelButton.addTarget(self, action: #selector(cancelButtonnClicked), for: .touchUpInside)
        mainView.reviewButton.addTarget(self, action: #selector(reviewButtonClicked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        mainView.sendButton.addTarget(self, action: #selector(touchButtonClicked), for: .touchUpInside)

    }
    
    @objc func sendButtonClicked() {
        checkCurrentState()
    }
    
    
    @objc func touchButtonClicked() {
        datas.append(mainView.chatTextView.text!)
        mainView.tableView.reloadData()
    }
    
    @objc func hideKeyBoard(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            mainView.chatTextView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRect.height
        }
        mainView.setUpKeyBoardConstraints(keyBoardHeight: keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        mainView.setUpConstraints()
    }
    
    @objc func reportButtonClicked() {
        
        let vc = ChatMenuViewController()
        vc.menuType = .report
        vc.mainView.title.text = "새싹 신고"
        vc.mainView.subTitle.text = "다시는 해당 새싹과 매칭되지 않습니다"
        vc.mainView.textView.text = "kiki"
        vc.mainView.confirmButton.setTitle("신고하기", for: .normal)
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func cancelButtonnClicked() {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        let vc = DeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.mainView.viewType = .dodge
        if UserInfo.current.dodged == 0 {
            vc.mainView.subTitle.text = "상대방이 약속을 취소했기 때문에 패널티가 부과되지 않습니다"
        }
        vc.uid = UserInfo.current.matchedUid
        vc.idToken = idToken
        vc.completion = { statusCode, uid in
            if statusCode == 200 {
                HomeApiService.stopFinding(idToken: idToken) { _, statusCode2 in
                    if statusCode2 == 200 {
                        UserDefaults.standard.set(0, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                        UserInfo.current.matched = 0
                    }
                }
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                print(statusCode)
            }
        }
        
        
        self.present(vc, animated: true, completion: nil)
    }
    @objc func reviewButtonClicked() {
        let vc = ChatMenuViewController()
        vc.menuType = .review
        vc.mainView.title.text = "리뷰 등록"
        vc.mainView.subTitle.text = "고래밥님과의 취미 활동은 어떠셨나요?"
        vc.mainView.textView.text = "kiki"
        vc.mainView.confirmButton.setTitle("gh", for: .normal)
        vc.completion = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func showExtraButtonClicked() {
        if self.mainView.moreView.isHidden {
            self.mainView.moreView.isHidden = false
            mainView.grayView.isHidden = false
        }else {
            self.mainView.moreView.isHidden = true
            mainView.grayView.isHidden = true
        }
    }
}
