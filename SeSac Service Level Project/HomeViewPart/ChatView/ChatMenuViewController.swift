//
//  ChatMenuViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/10.
//

import UIKit
import SnapKit

enum MenuType {
    case report
    case review
}

class ChatMenuViewController: UIViewController {
    
    let mainView = ChatMenuView()
    let viewModel = ChatMenuViewModel()
    var menuType: MenuType!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        
        view.addSubview(mainView)
        
        if menuType == .report {
            mainView.setUpConstraintsForReport()
            mainView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
                make.height.equalTo(410)
                make.width.equalToSuperview().offset(-32)
            }
        }else {
            mainView.setUpConstraintsForReview()
            mainView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
                make.height.equalTo(450)
                make.width.equalToSuperview().offset(-32)
            }
        }
        addTargets()
        
        
        mainView.layer.cornerRadius = 20
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    var completion: (() -> Void)?
    
    
    func addTargets() {
        mainView.cancelButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
    
    @objc func dismissButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonClicked() {
        guard let idToken = UserDefaults.standard.string(forKey: "idToken") else { return }
        switch menuType {
        case .report:
            
            HomeApiService.report(idToken: idToken, otherUid: UserInfo.current.matchedUid!, report: viewModel.selectedItems, comment: mainView.textView.text) { error, statusCode in
                if statusCode == 200 {
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print(statusCode, "error when report")
                }
                
            }
        case .review:
            
            HomeApiService.review(idToken: idToken, otherUid: UserInfo.current.matchedUid!, reputation: viewModel.selectedItems, comment: mainView.textView.text) { error, statusCode in
                if statusCode == 200 {
                    UserDefaults.standard.set(0, forKey: "CurrentUserState")
                    UserInfo.current.matched = 0
                    self.dismiss(animated: true, completion: nil)
                    self.completion?()
                }else {
                    print(statusCode, "error when review")
                }
            }
            
            
        case .none:
            print("what is this?")
        }
        
    }
    
}

extension ChatMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }
        
        if viewModel.selectedItems[indexPath.item] == 0 {
            cell.configureForeCellForItem(title: viewModel.cellForItemAt(indexPath: indexPath, type: menuType), selected: false)
        }else {
            cell.configureForeCellForItem(title: viewModel.cellForItemAt(indexPath: indexPath, type: menuType), selected: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if menuType == .report {
            return CGSize(width: collectionView.frame.width / 3 - 8, height: 32)
        }else {
            return CGSize(width: collectionView.frame.width / 2 - 8, height: 32)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ManageCollectionViewCell else { return }
        let selected = viewModel.selectedItems[indexPath.item]
        if selected == 0 {
            cell.configureForeCellForItem(title: cell.titleLabel.text!, selected: true)
            viewModel.selectedItems[indexPath.item] = 1
            cell.layer.borderWidth = 0
        }else {
            cell.configureForeCellForItem(title: cell.titleLabel.text!, selected: false)
            viewModel.selectedItems[indexPath.item] = 0
        }
    }
    
}
