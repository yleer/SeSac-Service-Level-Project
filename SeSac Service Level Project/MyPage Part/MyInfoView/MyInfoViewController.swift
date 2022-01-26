//
//  MyInfoViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit

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
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInSection 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = viewModel.cellForRowAt(cellForRowAt: indexPath)
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyInfoTableViewCell", for: indexPath) as? MyInfoTableViewCell else  { return UITableViewCell() }
            
            cell.profileImage.image = UIImage(named: data.0)
            cell.nameLabel.text = data.1
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyInfoSettingCell", for: indexPath) as? MyInfoSettingCell else { return UITableViewCell() }
            
            cell.settingImage.image = UIImage(named: data.0)
            cell.settingLabel.text = data.1
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = ManageMyInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            FireBaseService.getIdToken()
            if let idToken = UserDefaults.standard.string(forKey: "idToken") {
                print(idToken)
                ApiService.getUserInfo(idToken: idToken) { error, statusCode in
                    if error == nil {
                        if statusCode == 200 {
                        // home 화면으로
                       
                        }else {
                         
                        }
                    }else {
                        if statusCode == 401 {
                            
                        }else if statusCode == 500 {
                           
                        }else if statusCode == 501 {
                         
                        }
                    }
                }

            }
        }else {
            print(UserInfo.current.user)
        }
        
    }
}
