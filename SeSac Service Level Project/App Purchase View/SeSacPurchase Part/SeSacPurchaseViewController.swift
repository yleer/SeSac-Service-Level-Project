//
//  SeSacPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit

final class SeSacPurchaseViewController: UIViewController {
    
    let mainView = SeSacPurchaseView()
    let viewModel = SeSacPurchasViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}

extension SeSacPurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.numberOfRowAt, "check")
        return viewModel.numberOfRowAt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.identifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
        
        let row = indexPath.item
        
        cell.sesacImage.image = UIImage(named: viewModel.sessacInfo.sesacImageNames[row])
        cell.tilte.text = viewModel.sessacInfo.sesacTitles[row]
        cell.subTitle.text = viewModel.sessacInfo.sesacSubTitles[row]
        cell.price.setTitle(viewModel.sessacInfo.prices[row], for: .normal)
        cell.price.stateOfButton = .fill
        cell.price.addTarget(self, action: #selector(priceButtonClicked), for: .touchUpInside)
        cell.price.tag = row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 280)
    }
    @objc func priceButtonClicked(_ sender: UIButton) {
        print("price button clicked", sender.tag)
    }
}
