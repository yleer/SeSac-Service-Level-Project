//
//  AppPurchaseView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import Parchment
import SnapKit

class AppPurchaseView: UIView {
    
    let currentBackgroundImage = UIImageView()
    let saveButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(currentBackgroundImage)
    }
    
}
