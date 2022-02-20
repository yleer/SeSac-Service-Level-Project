//
//  BackgroundPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit

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
    }
}

extension BackgroundPurchaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowAt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackGroundTableViewCell.identifier, for: indexPath) as? BackGroundTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        
        cell.backGroundImage.image = UIImage(named: viewModel.backGroundInfo.backgroundImageNames[row])
        
        cell.layer.cornerRadius = 50
        cell.title.text = viewModel.backGroundInfo.backgroundTitles[row]
        cell.subTitle.text = viewModel.backGroundInfo.backgroundSubTitles[row]
        
        
        let priceData = viewModel.setPriceLabel(item: row)
        
        cell.price.setTitle(priceData.0, for: .normal)
        cell.price.stateOfButton = priceData.1
        cell.price.addTarget(self, action: #selector(priceButtonClicked), for: .touchUpInside)
        cell.price.tag = row
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        185
    }
    
    @objc func priceButtonClicked(_ sender: UIButton) {
        print("price button clicked", sender.tag)
    }
}
