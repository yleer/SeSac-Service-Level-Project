//
//  MyInfoViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import Toast

final class MyInfoViewController: UIViewController {
    
    private let viewModel = MyInfoViewModel()
    private let mainView = MyInfoView()

    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = "내 정보"
        addTargets()
    }
    
    
    
    private func addTargets() {
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
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            self.tabBarController?.selectedIndex = 0
        }else if userState == 1 {
            self.tabBarController?.selectedIndex = 0
            let vc = NearUserPageMenuController()
            vc.isSecond = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    func getInfo() {
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
                ApiService.getUserInfo(idToken: idToken) { error, statusCode in
                    
                    guard let error = error else {
                        if statusCode == 200 {
                            let vc = ManageMyInfoViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        print(statusCode, "sdafaf")
                        return
                    }
                    
                    switch error {
                    case .firebaseTokenError(let errorContent):
                        FireBaseService.getIdToken(completion: nil)
                        self.view.makeToast(errorContent)
                    case .serverError(let errorContent):
                        self.view.makeToast(errorContent)
                    case .clientError(let errorContent):
                        self.view.makeToast(errorContent)
                    case .alreadyWithdrawl(let errorContent):
                        self.view.makeToast(errorContent)
                    }
                }

            }
        }
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInSection 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = viewModel.cellForRowAt(cellForRowAt: indexPath)
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifier, for: indexPath) as? MyInfoTableViewCell else  { return UITableViewCell() }
            cell.configureFromCellForRowAt(image: UIImage(named: data.0)!, text: data.1)
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoSettingCell.identifier, for: indexPath) as? MyInfoSettingCell else { return UITableViewCell() }
            cell.configureFromCellForRowAt(image: UIImage(named: data.0)!, text: data.1)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRowAt)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            getInfo()
            
        }
        else {
            
            FireBaseService.getIdToken {
                if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
                    ApiService.getUserInfo(idToken: idToken) { error, statusCode in
                        
                        print(idToken)
                        guard let error = error else {
                            if statusCode == 200 {
                                print("good")
                            }
                            print(statusCode, "sdafaf")
                            return
                        }
                    }
                }
            }
            print(UserInfo.current.user)
            
        }
    }
}



