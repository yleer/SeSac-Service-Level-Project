//
//  ReviewViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/09.
//

import UIKit

class ReviewViewController: UIViewController {
    let noReiviewView = NoReviewVIew()
    let mainView = ReviewView()
    var reviews: [String] = []
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = UITableView.automaticDimension
        
        if reviews.count == 0 {
            self.view = noReiviewView
        }else {
            self.view = mainView
            mainView.tableView.reloadData()
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else { return UITableViewCell()}
        
        
        cell.label.text = reviews[indexPath.row]
        
        return cell
    }
    
    
}
