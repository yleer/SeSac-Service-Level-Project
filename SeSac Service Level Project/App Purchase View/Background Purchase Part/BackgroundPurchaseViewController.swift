//
//  BackgroundPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import StoreKit

final class BackgroundPurchaseViewController: UIViewController {
    
    let mainView = BackgroundPurchaseView()
    let viewModel = BackGroundViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
   }
    
                                            
    @objc func handlePurchaseNotification(_ notification: Notification) {
        viewModel.purchasedList = UserInfo.current.user?.backgroundCollection
        reload()
    }
                                               
                                               
    
    var product: SKProduct?
    var products: [SKProduct] = []
                                               
    var changeBackgroundCompletion: ((Int) -> Void)?
    
    // App Store에서 상품 정보 request -> tableview reload
    @objc func reload() {
        products = []
        
        BackgroundProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
            // app store에서 상품 정보 가져오기 성공하면
          if success {
            self.products = products!
              DispatchQueue.main.async {
                  self.mainView.tableView.reloadData()
              }
           }
        }
    }
}

extension BackgroundPurchaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackGroundTableViewCell.identifier, for: indexPath) as? BackGroundTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        
        if indexPath.row == 0 {
            cell.title.text = viewModel.backGroundInfo.backgroundTitles[row]
            cell.subTitle.text = viewModel.backGroundInfo.backgroundSubTitles[row]
            cell.price.setTitle(viewModel.backGroundInfo.prices[row], for: .normal)
        }else {
            cell.title.text = products[row - 1].localizedTitle
            cell.subTitle.text = products[row - 1].localizedDescription
            cell.price.setTitle("\(products[row - 1].price)", for: .normal)
        }
        
        let priceData = viewModel.setPriceLabel(item: row)
        cell.price.stateOfButton = priceData.1
        
        if cell.price.titleLabel?.text == "0" {
            cell.price.setTitle("보유", for: .normal)
        }
        
        
        cell.price.tag = row
        cell.backGroundImage.image = UIImage(named: viewModel.backGroundInfo.backgroundImageNames[row])
        
    
        cell.price.addTarget(self, action: #selector(priceButtonClicked), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeBackgroundCompletion?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        185
    }
    
    @objc func priceButtonClicked(_ sender: UIButton) {
        guard let button = sender as? InActiveButton else { return }
        
        if button.stateOfButton == .inActive {
            view.makeToast("이미 구매한 상품입니다")
        }else {
            let itemToBuy = products[sender.tag - 1]
            BackgroundProducts.store.buyProduct(itemToBuy)
        }
        print("price button clicked", sender.tag)
    }
}
