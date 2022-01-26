//
//  HomeViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    let mainView = HomeView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .brandGreen
        
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
}
