//
//  NickNameViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import UIKit

class NickNameViewController: UIViewController {
    
    let mainView = NickNameView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
