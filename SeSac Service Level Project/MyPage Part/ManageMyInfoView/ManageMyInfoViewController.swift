//
//  ManageMyInfoViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import UIKit
import RangeSeekSlider

class ManageMyInfoViewController: UIViewController {
    
    let mainView = ManageMyInfoView()
    let viewModel = ManageViewModel()
    
    let user: User! = UserInfo.current.user
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        title = "정보 관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(navButtonClicked))
    }

    
    
    @objc func navButtonClicked() {
        print(viewModel.updatedData.value)
 
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            ApiService.updateUserInfo(searchable: viewModel.updatedData.value.searchable, min: viewModel.updatedData.value.ageMin, max: viewModel.updatedData.value.ageMax, gender: viewModel.updatedData.value.gender, hobby: viewModel.updatedData.value.hobby, idToken: idToken)
            
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
    }
}

extension ManageMyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoImageCell.identifier, for: indexPath) as? ManageMyInfoImageCell else { return UITableViewCell() }
//            cell.profileImage.image = UIImage(named: )
            return cell
        }
        
        else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoPersonalInfoCell.identifier, for: indexPath) as? ManageMyInfoPersonalInfoCell else { return UITableViewCell() }
    
            cell.colletionView.delegate = self
            cell.colletionView.dataSource = self
            
            cell.nameLabel.text = UserInfo.current.user?.nick
            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            return cell
        }
        
        else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoAgeRangeCell.identifier, for: indexPath) as? ManageMyInfoAgeRangeCell else { return UITableViewCell() }

            cell.configureFromCellForRowAt(min: CGFloat(UserInfo.current.user!.ageMin), max: CGFloat(UserInfo.current.user!.ageMax), text: "\(UserInfo.current.user!.ageMin)-\(UserInfo.current.user!.ageMax)")
            
            cell.rangeSeeker.addTarget(self, action: #selector(sldierValueChagned), for: .allEvents)
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyGenderCell.identifier, for: indexPath) as? MyGenderCell else { return UITableViewCell() }
            
            if indexPath.row == 2 {
                cell.configureFromCellForRowAt(title: "내 성별", type: .gender)
                cell.genderButton(gender: UserInfo.current.user!.gender)
                cell.maleButton.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
                cell.femaleButton.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
            }else if indexPath.row == 3{
                cell.configureFromCellForRowAt(title: "자주 하는 취미", type: .hobby)
                cell.textFieldView.text = user.hobby
                cell.textFieldView.addTarget(self, action: #selector(hobbyTextfiledChagned), for: .editingChanged)
            }else if indexPath.row == 4 {
                cell.configureFromCellForRowAt(title: "내 번호 검색 허용", type: .searchable)
                cell.phoneSwitch.isOn = user.searchable == 0 ? false : true
                cell.phoneSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            }else if indexPath.row == 6 {
                cell.configureFromCellForRowAt(title: "회원탈퇴", type: .withdrawl)
            }
            return cell
        }
    }
    
    @objc func maleButtonClicked() {
        viewModel.updatedData.value.gender = 1
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? MyGenderCell else { return }
        cell.genderButton(gender: viewModel.updatedData.value.gender)
    }
    
    @objc func femaleButtonClicked() {
        viewModel.updatedData.value.gender = 0
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? MyGenderCell else { return }
        cell.genderButton(gender: viewModel.updatedData.value.gender)
    }
    
    @objc func hobbyTextfiledChagned(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.updatedData.value.hobby = text
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        viewModel.updatedData.value.searchable = sender.isOn ? 1 : 0
    }
    

    @objc func sldierValueChagned(_ sender: RangeSeekSlider) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? ManageMyInfoAgeRangeCell else { return }
        viewModel.updatedData.value.ageMin = Int(sender.selectedMinValue)
        viewModel.updatedData.value.ageMax = Int(sender.selectedMaxValue)
        
        viewModel.updatedData.bind { user in
            cell.selectedAgeRangeLabel.text = "\(user.ageMin)-\(user.ageMax)"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRowAt(indexPath: indexPath))
    }
    
    @objc func moreButtonClicked(_ sender: UIButton) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ManageMyInfoPersonalInfoCell else {
            return
        }
        viewModel.open = !viewModel.open
        cell.full = !cell.full
        mainView.tableView.reloadData()
    }
}




extension ManageMyInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }

        cell.configureForeCellForItem(title: viewModel.cellForItemAt(indexPath: indexPath), selected: user.reputation[indexPath.row] > 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 8, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}



