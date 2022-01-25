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
    var full = false
    
    
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
        
        else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoPersonalInfoCell.identifier, for: indexPath) as? ManageMyInfoPersonalInfoCell else { return UITableViewCell() }
            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            cell.colletionView.delegate = self
            cell.colletionView.dataSource = self
            cell.nameLabel.text = UserInfo.current.user?.nick
            return cell
        }
        
        else if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoAgeRangeCell.identifier, for: indexPath) as? ManageMyInfoAgeRangeCell else { return UITableViewCell() }
            cell.rangeSeeker.addTarget(self, action: #selector(sldierValueChagned), for: .allEvents)
            cell.rangeSeeker.selectedMinValue = CGFloat(UserInfo.current.user!.ageMin)
            cell.rangeSeeker.selectedMaxValue = CGFloat(UserInfo.current.user!.ageMax)
            cell.selectedAgeRangeLabel.text = "\(UserInfo.current.user!.ageMin)-\(UserInfo.current.user!.ageMax)"
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyGenderCell.identifier, for: indexPath) as? MyGenderCell else { return UITableViewCell() }
            
            if indexPath.row == 2 {
                cell.settingTitle.text = "내 성별"
                cell.stackView.isHidden = false
                cell.textFieldView.isHidden = true
                cell.maleButton.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
                cell.femaleButton.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
                
                if UserInfo.current.user?.gender == 0 {
                    cell.maleButton.backgroundColor = UIColor(named: "brand colorgreen")
                    cell.femaleButton.backgroundColor = .white
                }else if UserInfo.current.user?.gender == 1{
                    cell.maleButton.backgroundColor = .white
                    cell.femaleButton.backgroundColor = UIColor(named: "brand colorgreen")
                }
                
            }else if indexPath.row == 3{
                cell.settingTitle.text = "자주 하는 취미"
                cell.textFieldView.isHidden = false
                cell.stackView.isHidden = true
                cell.textFieldView.addTarget(self, action: #selector(hobbyTextfiledChagned), for: .editingChanged)
                if UserInfo.current.user?.hobby != "" {
                    cell.textFieldView.text = UserInfo.current.user?.hobby
                }
            }else if indexPath.row == 4 {
                cell.settingTitle.text = "내 번호 검색 허용"
                cell.phoneSwitch.isHidden = false
                cell.phoneSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
                
                if UserInfo.current.user?.searchable == 0{
                    cell.phoneSwitch.isOn = false
                }else {
                    cell.phoneSwitch.isOn = true
                }
                
                
            }else if indexPath.row == 6 {
                cell.settingTitle.text = "회원탈퇴"
            }
            return cell
        }
    }
    
    @objc func maleButtonClicked() {
        viewModel.updatedData.value.gender = 0
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? MyGenderCell else { return }
        
        cell.maleButton.backgroundColor = UIColor(named: "brand colorgreen")
        cell.femaleButton.backgroundColor = .white
    }
    
    @objc func femaleButtonClicked() {
        viewModel.updatedData.value.gender = 1
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? MyGenderCell else { return }
        
        cell.maleButton.backgroundColor = .white
        cell.femaleButton.backgroundColor = UIColor(named: "brand colorgreen")
    }
    
    @objc func hobbyTextfiledChagned(_ sender: UITextField) {
        print(viewModel.updatedData.value)
        if let text = sender.text {
            viewModel.updatedData.value.hobby = text
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        print(viewModel.updatedData.value)
        viewModel.updatedData.value.searchable = sender.isOn ? 1 : 0
    }
    

    @objc func sldierValueChagned(_ sender: RangeSeekSlider) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? ManageMyInfoAgeRangeCell else { return }
        print(viewModel.updatedData.value)
        viewModel.updatedData.value.ageMin = Int(sender.selectedMinValue)
        viewModel.updatedData.value.ageMax = Int(sender.selectedMaxValue)
        cell.selectedAgeRangeLabel.text = "\(Int(sender.selectedMinValue))-\(Int(sender.selectedMaxValue))"
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRowAt(indexPath: indexPath))
    }
    
    @objc func moreButtonClicked(_ sender: UIButton) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ManageMyInfoPersonalInfoCell else {
            print("check")
            return
        }
//        cell.full = !cell.full
//        full = cell.full
        
        viewModel.open = !viewModel.open
        cell.full = !cell.full
        mainView.tableView.reloadData()
    }
    
}

extension ManageMyInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }
//        cell.backgroundColor = .blue
        cell.titleLabel.text = viewModel.cellForItemAt(indexPath: indexPath)
        
        if UserInfo.current.user!.reputation[indexPath.row] > 0 {
            cell.backgroundColor = UIColor(named: "brand colorgreen")
            cell.titleLabel.textColor = .white
            cell.layer.borderColor = nil
        }else {
            cell.backgroundColor = .white
            cell.clipsToBounds = true
            cell.titleLabel.textColor = .black
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.gray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 8, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    
    
}
