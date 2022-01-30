//
//  HobbySearchViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/27.
//

import UIKit
import Toast

class HobbySearchViewController: UIViewController {
    
    let viewModel = HobbySeachViewModel()
    let mainView = HobbySearchView()
    let data = ["아무거나","SeSAC", "코딩","맛집탐방","공원산책","독서모임","다육이", "쓰레기줍기"]

    let searchBar = UISearchBar()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.secondCollectionView.delegate = self
        mainView.secondCollectionView.dataSource = self
        
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        mainView.findFreindsButton.addTarget(self, action: #selector(findButtonCilcked), for: .touchUpInside)
    }
    
    @objc func findButtonCilcked() {
        print("Hello")
//        FireBaseService.getIdToken {
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            print(idToken)
            print(viewModel.requestParameter!)
            ApiService.requestToFindFriends(idToken: idToken, parameter: self.viewModel.requestParameter!) { error, statusCode in
                print(error, statusCode)
            }
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    
    @objc func keyboardWillShow(_ sender: Notification) {
        print("heool")
        var keyboardHeight: CGFloat = 0
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            
            keyboardHeight = keyboardRect.height
            
        }
        mainView.setUpWhenKeyBoardConstraints(keyBoardHeight: keyboardHeight)
    }
    @objc func keyboardWillHide() {
        print("by")
        mainView.setUpNormalConstraints()
    }
    
    @objc func addTapped() {
        if viewModel.myInterestHobbies.count < 8 {
            if let text = searchBar.text, text.count >= 1, text.count < 9 {
                viewModel.newSearchKeywords(keyWords: text)
                mainView.secondCollectionView.reloadData()
            }else {
                self.view.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다")
            }
        }else {
            self.view.makeToast("취미를 더 이상 추가할 수 없습니다")
        }
        searchBar.endEditing(true)
    }
    
}

extension HobbySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.collectionView  {
           return data.count
        }
        return viewModel.myInterestHobbies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizingCell.identifier, for: indexPath) as? SizingCell else {return UICollectionViewCell()}
        
        
        
        if collectionView == mainView.collectionView {
            cell.hobbyLabel.text = data[indexPath.item]
        }else {
            cell.hobbyLabel.text = viewModel.myInterestHobbies[indexPath.item]
            cell.cellType = .myHobby
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.secondCollectionView {
            viewModel.myInterestHobbies.remove(at: indexPath.item)
            mainView.secondCollectionView.reloadData()
        }
    }
}


