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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hll")
            viewModel.onqueueCall{
                if self.viewModel.queueDB.count > 0 {
                    self.view = self.mainView
                    self.mainView.tableView.reloadData()
                }else{
                    self.view = self.emptyView
                }
            }
    }

    lazy var isFull = Array(repeating: false, count: viewModel.queueDB.count)
    
    override func loadView() {
        super.loadView()
        self.view = emptyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        addTargets()
        
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func addTargets() {
        emptyView.changeHobbyButton.addTarget(self, action: #selector(changeHobbyButtonClicked), for: .touchUpInside)
        emptyView.refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func changeHobbyButtonClicked() {
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            HomeApiService.stopFinding(idToken: idToken) { error, statusCode in
                if let error = error {
                    switch error {
                    case .firebaseTokenError(let errorContent), .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                        self.view.makeToast(errorContent)
                    }
                }else {
                    
                    if statusCode == 200 {
                        UserDefaults.standard.set(0, forKey: "CurrentUserState")
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }else if statusCode == 201 {
                        self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
                    }
                    
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshButtonClicked() {
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

extension NearUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.queueDB.count * 3
    }
    
    @objc func requestButtonTapped(_ sender: UIButton) {

        let vc = DeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.mainView.viewType = .request
        guard let idToken = UserDefaults.standard.string(forKey: "idToken") else { return }
        vc.idToken = idToken
        vc.completion = { statusCode, uid in
            if statusCode == 200 {
                self.view.makeToast("취미 함께 하기 요청을 보냈습니다")
                self.mainView.tableView.reloadData()
            }else if statusCode == 201 {
                HomeApiService.acceptRequest(idToken: idToken, otherUid: uid) { error, statusCode2 in
                    if statusCode2 == 200 {
                        UserDefaults.standard.set(2, forKey: "CurrentUserState")
                        self.view.makeToast("상대방도 취미 함께 하기를 요청했습니다. 채팅방으로 이동합니다")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let vc = ChattingViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                        
                }
                
            }else if statusCode == 202 {
                self.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다")
            }
        }
        vc.uid = viewModel.queueDB[sender.tag / 3].uid
        self.present(vc, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoImageCell.identifier, for: indexPath) as? ManageMyInfoImageCell else { return UITableViewCell() }
            cell.cellType = .requestButton
            cell.checkButtonState()
            cell.button.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
            cell.tag = indexPath.row
            return cell
            
        }else if indexPath.row % 3 == 1 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ManageMyInfoPersonalInfoCell.identifier, for: indexPath) as? ManageMyInfoPersonalInfoCell else  { return UITableViewCell() }

            cell.colletionView.delegate = self
            cell.colletionView.dataSource = self
            cell.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            cell.nameLabel.text = viewModel.queueDB[indexPath.row - 1].nick
            cell.infoCellType = .hobby
            cell.colletionView.tag = (indexPath.row - 1) * 3
            cell.wantHobbies.tag = (indexPath.row - 1) * 3 + 1
            cell.wantHobbies.delegate = self
            cell.wantHobbies.dataSource = self
            cell.moreButtonForReview.isHidden = true

            
            
            cell.moreButton.tag = indexPath.row

            return cell

        }else {
            return UITableViewCell()
        }
    }
    @objc func moreButtonClicked(_ sedner: UIButton) {
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ManageMyInfoPersonalInfoCell else {
            return
        }
        cell.full = !cell.full
        isFull[sedner.tag - 1] = !isFull[sedner.tag - 1]
        mainView.tableView.reloadData()
    }
}


extension NearUserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag % 2 == 0  {
            return 6
        }else {
            print("this?")
            return viewModel.queueDB[(collectionView.tag - 1) / 2].hf.count
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag % 2 == 0  {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }

            cell.configureForeCellForItem(title: viewModel.cellForItemAt(indexPath: indexPath), selected: viewModel.queueDB[collectionView.tag].reputation[indexPath.row] > 0)
            return cell
        }else {
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
//            return UICollectionViewFlowLayout.automaticSize
//            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }


}





    
    
