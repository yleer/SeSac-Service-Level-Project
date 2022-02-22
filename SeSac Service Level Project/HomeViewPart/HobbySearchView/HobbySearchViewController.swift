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

    let searchBar = UISearchBar()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNeighborHobbies {
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
        }
    }
    
    private func configureViews() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.secondCollectionView.delegate = self
        mainView.secondCollectionView.dataSource = self
        
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    private func addTargets() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard(sender:))))
        
        mainView.findFreindsButton.addTarget(self, action: #selector(findButtonCilcked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReqeustPush),
                                               name: .requestPush,
                                               object: nil)
    }
    // MARK: Notification
    @objc func handleReqeustPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            self.navigationController?.popViewController(animated: true)
        }else if userState == 1 {
            let vc = NearUserPageMenuController()
            vc.isSecond = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: 새싹찾기 버튼 누름
    @objc func findButtonCilcked() {
        
        FireBaseService.getIdToken {
        if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
            ApiService.requestToFindFriends(idToken: idToken, parameter: self.viewModel.requestParameter!) { error, statusCode in
                if let error = error {
                    // error handler
                    print(error, statusCode)
                }else {
                    if statusCode == 200 {
                        // 화면 전환 해야 됨
                        // 화면(1_3_near_user & 1_4_accept)으로 전환합니다.
                        UserDefaults.standard.set(1, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                        let vc = NearUserPageMenuController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        print("성공")
                    }else if statusCode == 201 {
                        self.view.makeToast("신고가 누적되어 이용하실 수 없습니다")
                    }else if statusCode == 203 {
                        self.view.makeToast("약속 취소 패널티로, 1분동안 이용하실 수 없습니다")
                    }else if statusCode == 204 {
                        self.view.makeToast("약속 취소 패널티로, 2분동안 이용하실 수 없습니다")
                    }else if statusCode == 205 {
                        self.view.makeToast("연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다")
                    }else if statusCode == 206 {
                        self.view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            let viewCont = MyInfoViewController()
                            viewCont.getInfo()
                            self.navigationController?.pushViewController(viewCont, animated: false)
                        }
                    }

                }
            }

            }
        }
    }

    @objc func hideKeyBoard(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        var keyboardHeight: CGFloat = 0
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRect.height
        }
        mainView.setUpWhenKeyBoardConstraints(keyBoardHeight: keyboardHeight)
    }
    
    @objc func keyboardWillHide() {
        mainView.setUpNormalConstraints()
    }
}

extension HobbySearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if viewModel.myInterestHobbies.count < 8 {
            if let text = searchBar.text, text.count >= 1, text.count < 9 {
                if viewModel.myInterestHobbies.contains(text) {
                    self.view.makeToast("이미 등록된 취미입니다")
                }else {
                    viewModel.newSearchKeywords(keyWords: text)
                    mainView.secondCollectionView.reloadData()
                }
                
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
            return viewModel.allHobbies.count
        }
        return viewModel.myInterestHobbies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizingCell.identifier, for: indexPath) as? SizingCell else {return UICollectionViewCell()}
        
        if collectionView == mainView.collectionView {
            if indexPath.item < viewModel.recommendationHobbies.count {
                cell.cellType = .nearBySpecial
            }else {
                cell.cellType = .defaultType
            }
            cell.hobbyLabel.text = viewModel.allHobbies[indexPath.item]
            
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
        }else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? SizingCell, let text = cell.hobbyLabel.text else { return }
            if viewModel.myInterestHobbies.count < 8{
                if viewModel.myInterestHobbies.contains(text) {
                    self.view.makeToast("이미 등록된 취미입니다")
                }else {
                    viewModel.myInterestHobbies.append(text)
                    mainView.secondCollectionView.reloadData()
                }
            }else {
                self.view.makeToast("취미를 더 이상 추가할 수 없습니다")
            }
        }
    }
    
}


