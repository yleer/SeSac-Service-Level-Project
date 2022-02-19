//
//  SeSacPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit

final class SeSacPurchaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("sesac purchase")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
    }
}
