//
//  SeSacPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import StoreKit

final class SeSacPurchaseViewController: UIViewController {
    
    let mainView = SeSacPurchaseView()
    let viewModel = SeSacPurchasViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    @objc func handlePurchaseNotification(_ notification: Notification) {
        print("noti called")
      reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    var product: SKProduct?
    var products: [SKProduct] = []
    var changeSeSacCompletion: ((Int) -> Void)?


    @objc func reload() {
        products = []
        
        mainView.collectionView.reloadData()
        RazeFaceProducts.store.purchaseCompleteHandler = reload
        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
          if success {
            self.products = products!
            
              DispatchQueue.main.async {
                  self.mainView.collectionView.reloadData()
              }
              
          }
        
        }
    }
}

extension SeSacPurchaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.identifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
        
        let row = indexPath.item
        
        if row == 0 {
            cell.tilte.text = viewModel.sessacInfo.sesacTitles[row]
            cell.subTitle.text = viewModel.sessacInfo.sesacSubTitles[row]
            cell.price.setTitle(viewModel.sessacInfo.prices[row], for: .normal)
        }else {
            cell.tilte.text = products[row - 1].localizedTitle
            cell.subTitle.text = products[row - 1].localizedDescription
            cell.price.setTitle("\(products[row - 1].price)", for: .normal)
        }

        let priceData = viewModel.setPriceLabel(item: row)
        cell.price.stateOfButton = priceData.1
        cell.sesacImage.image = UIImage(named: viewModel.sessacInfo.sesacImageNames[row])
        
        if cell.price.titleLabel?.text == "0" {
            cell.price.setTitle("보유", for: .normal)
        }
        
        cell.price.addTarget(self, action: #selector(priceButtonClicked), for: .touchUpInside)
        cell.price.tag = row
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 280)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeSeSacCompletion?(indexPath.item)
    }
    
    @objc func priceButtonClicked(_ sender: UIButton) {
        
        guard let button = sender as? InActiveButton else { return }
        
        if button.stateOfButton == .inActive {
            view.makeToast("이미 구매한 상품입니다")
        }else {
            let itemToBuy = products[sender.tag - 1]
            RazeFaceProducts.store.buyProduct(itemToBuy)
        }
        print("price button clicked", sender.tag)
    }
}
