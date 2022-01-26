//
//  MyPageNavigationController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit

class MyPageNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setViewControllers([MyInfoViewController()], animated: true)
        
        self.title = "내 정보"
    }
    
}
