//
//  NearUserViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/01.
//

import UIKit

class NearUserViewController: UIViewController {
    
    let viewModel = NearUserViewModel()
    let mainView = NearUserView()
    let emptyView = NearUserEmptyView()
    var mTimer : Timer?
    lazy var isFull = Array(repeating: false, count: viewModel.queueDB.count)
    
    var idToken: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeMainView()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let timer = mTimer {
            if(timer.isValid){
                timer.invalidate()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = emptyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        addTargets()
        mainView.tableView.register(ManageMyInfoPersonalInfoCell.self, forCellReuseIdentifier: ManageMyInfoPersonalInfoCell.identifier)
        mainView.tableView.rowHeight = UITableView.automaticDimension
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        self.idToken = idToken
    }
}

extension NearUserViewController {
    
    func startTimer() {
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        }else{
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            mTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
            
    @objc func timerCallback(){
        HomeApiService.myQueueState(idToken: idToken) { error, statusCode in
            if statusCode == 200 {
                if let matched = UserInfo.current.matched {
                    print("matched berofre in", matched)
                    if matched == 1{
                        UserDefaults.standard.set(2, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                        self.view.makeToast("\(UserInfo.current.matchedNick!)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let vc = ChattingViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else {
                        
                    }
                }
            }else {
                print("not able to get user state", statusCode)
            }
        }
        changeMainView()
   }
    
    private func changeMainView() {
        viewModel.onqueueCall{
            if self.viewModel.queueDB.count > 0 {
                self.view = self.mainView
                self.mainView.tableView.reloadData()
            }else{
                self.view = self.emptyView
            }
        }
    }

}
    
extension NearUserViewController {
    
    func addTargets() {
        emptyView.changeHobbyButton.addTarget(self, action: #selector(changeHobbyButtonClicked), for: .touchUpInside)
        emptyView.refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCancelPush),
                                               name: .cancelPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReqeustPush),
                                               name: .requestPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAcceptPush),
                                               name: .acceptPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleChatPush),
                                               name: .chatPush,
                                               object: nil)
    }
    
    @objc func handleCancelPush() {}
    @objc func handleChatPush() {}
    @objc func handleAcceptPush() {}
    @objc func handleReqeustPush() {
        guard let vc = self.parent as? NearUserPageMenuController else { return }
        vc.isSecond = true
    }
    
    
    @objc func changeHobbyButtonClicked() {
        HomeApiService.stopFinding(idToken: idToken) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    self.view.makeToast(errorContent)
                    self.changeHobbyButtonClicked()
                case.serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                    self.view.makeToast(errorContent)
                }
            }else {
                
                if statusCode == 200 {
                    UserDefaults.standard.set(0, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else if statusCode == 201 {
                    self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
                }
                
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshButtonClicked() {
        changeMainView()
    }
}

extension NearUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.queueDB.count * 3
    }
    
    @objc func requestButtonTapped(_ sender: UIButton) {
        let vc = DeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.mainView.viewType = .request
        vc.idToken = idToken
        vc.otherUid = viewModel.queueDB[sender.tag].uid
        vc.completion = { statusCode, uid in
            if statusCode == 200 {
                self.view.makeToast("취미 함께 하기 요청을 보냈습니다")
                self.mainView.tableView.reloadData()
            }else if statusCode == 201 {
                HomeApiService.acceptRequest(idToken: self.idToken, otherUid: uid) { error, statusCode2 in
                    if statusCode2 == 200 {
                        UserDefaults.standard.set(2, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                        self.view.makeToast("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다")
                        HomeApiService.myQueueState(idToken: self.idToken) { error, statusCode3 in
                            if statusCode3 == 200 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    let vc = ChattingViewController()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                        
                    }
                }
            }else if statusCode == 202 {
                self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다")
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    private func getBackGroundImage(num: Int) -> UIImage? {
        if num == 0 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background1)
        }else if num == 1 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background2)
        }else if num == 2 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background3)
        }else if num == 3 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background4)
        }else if num == 4 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background5)
        }else if num == 5 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background6)
        }else if num == 6 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background7)
        }else {
            return UIImage(named: ImageNames.AppPurchaseViewController.background8)
        }
        
    }
    
    private func getSeSacImage(num: Int) -> UIImage? {
        if num == 0 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img)
        }else if num == 1 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img1)
        }else if num == 2 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img2)
        }else if num == 3 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img3)
        }else {
            return UIImage(named: ImageNames.AppPurchaseViewController.img4)
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoImageCell.identifier, for: indexPath) as? ManageMyInfoImageCell else { return UITableViewCell() }
            cell.cellType = .requestButton
            cell.button.setTitle("요청하기", for: .normal)
            cell.checkButtonState()
            cell.button.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
            cell.button.tag = indexPath.row / 3
            cell.profileImage.image = getBackGroundImage(num: viewModel.queueDB[indexPath.row / 3].background)
            cell.sesacImage.image = getSeSacImage(num: viewModel.queueDB[indexPath.row / 3].sesac)
            return cell
            
        }else if indexPath.row % 3 == 1 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoPersonalInfoCell.identifier, for: indexPath) as? ManageMyInfoPersonalInfoCell else  { return UITableViewCell() }

            cell.colletionView.delegate = self
            cell.colletionView.dataSource = self
            
//            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            cell.nameLabel.text = viewModel.queueDB[indexPath.row / 3 ].nick
            cell.infoCellType = .hobby
            
            cell.colletionView.tag = (indexPath.row / 3) * 2
            cell.wantHobbies.tag = (indexPath.row / 3) * 2 + 1
            
            cell.wantHobbies.delegate = self
            cell.wantHobbies.dataSource = self
            cell.moreButtonForReview.isHidden = true

            
            
            cell.moreButton.tag = indexPath.row

            return cell

        }else {
            return UITableViewCell()
        }
    }
//    @objc func moreButtonClicked(_ sedner: UIButton) {
//        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: sedner.tag)) as? ManageMyInfoPersonalInfoCell else {
//            return
//        }
//        cell.full = !cell.full
//        isFull[indexPath.row / 3] = !isFull[indexPath.row / 3]
//        mainView.tableView.reloadData()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 3 == 1{
            
            guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ManageMyInfoPersonalInfoCell else {
                return
            }
            print("before",cell.nameLabel.text, cell.full)
            cell.full = !cell.full
            print("after",cell.nameLabel.text, cell.full)
//            isFull[indexPath.row / 3] = !isFull[indexPath.row / 3]
//            mainView.tableView.reloadData()
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
            
        }
    }
}


extension NearUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag % 2 == 0  {
            return 6
        }else {
            print("this?")
//            (indexPath.row / 3) * 2 + 1
            return viewModel.queueDB[(collectionView.tag - 1) / 2].hf.count
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag % 2 == 0  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }

            cell.configureForeCellForItem(title: viewModel.cellForItemAt(indexPath: indexPath), selected: viewModel.queueDB[collectionView.tag / 2].reputation[indexPath.row] > 0)
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizingCell.identifier, for: indexPath) as? SizingCell else { return UICollectionViewCell() }
            cell.cellType = .defaultType
            cell.hobbyLabel.text = viewModel.queueDB[(collectionView.tag - 1) / 2].hf[indexPath.item]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag % 2 == 0  {
            return CGSize(width: collectionView.frame.width / 2 - 8, height: 32)
        }else {
            return CGSize(width: collectionView.frame.width / 2 - 8, height: 32)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}





    
    
