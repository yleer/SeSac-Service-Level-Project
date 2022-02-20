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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        reload()
    }
    
    var product: SKProduct?
    var products: [SKProduct] = []
    
    func recepitValidation(transaction: SKPaymentTransaction, productIdentifier: String) {
        let recipitFileUrl = Bundle.main.appStoreReceiptURL
        let reciptData = try? Data(contentsOf: recipitFileUrl!)
        let reciptString = reciptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(reciptString)
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    
    @objc func reload() {
        products = []
        
        mainView.collectionView.reloadData()
        
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
    @objc func priceButtonClicked(_ sender: UIButton) {
        print("price button clicked", sender.tag)
    }
}
