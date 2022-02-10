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
        
        mainView.cancelButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        mainView.layer.cornerRadius = 20
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    @objc func dismissButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageCollectionViewCell.identifier, for: indexPath) as? ManageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.titleLabel.text = viewModel.cellForItemAt(indexPath: indexPath, type: menuType)
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
    
}
