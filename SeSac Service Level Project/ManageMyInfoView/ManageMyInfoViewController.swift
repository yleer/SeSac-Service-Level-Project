//
//  ManageMyInfoViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit

class ManageMyInfoViewController: UIViewController {
    
    let mainView = ManageMyInfoView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        title = "정보 관리"
    
    }
    var full = false
}

extension ManageMyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoImageCell.identifier, for: indexPath) as? ManageMyInfoImageCell else { return UITableViewCell() }
            
            return cell
        }else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoPersonalInfoCell.identifier, for: indexPath) as? ManageMyInfoPersonalInfoCell else { return UITableViewCell() }
            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)  
            return cell
        }else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyGenderCell.identifier, for: indexPath) as? MyGenderCell else { return UITableViewCell() }
            
            
            return cell
        }else {
            return UITableViewCell()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 194
        }else if indexPath.row == 1 {
         
            if full {
                print("full")
                return 300
            }else {
                print("emprt")
                return 100
            }
            
        }else if indexPath.row == 2{
            return 80
        }else {
            return 80
        }

    }
    
    @objc func moreButtonClicked(_ sender: UIButton) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ManageMyInfoPersonalInfoCell else {
            print("check")
            return
            
        }
        cell.full = !cell.full
        full = cell.full
        mainView.tableView.reloadData()
    }
    
}
