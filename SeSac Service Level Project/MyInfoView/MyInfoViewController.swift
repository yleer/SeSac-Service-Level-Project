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
        title = "내 정보"
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
        let vc = ManageMyInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

