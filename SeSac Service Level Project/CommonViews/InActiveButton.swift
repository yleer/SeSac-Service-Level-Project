//
//  InActiveButton.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/18.
//

import UIKit

enum ButtonState {
    case inActive
    case fill
    case outline
    case cancel
    case disable
}


class InActiveButton: UIButton {
    var stateOfButton: ButtonState = .fill {
        didSet{
            switch stateOfButton {
            case .inActive:
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = .white
                self.layer.borderColor = UIColor(named: "grayscalegray4")?.cgColor
                self.isEnabled = true
            case .fill:
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = UIColor(named: "brand colorgreen")
                self.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
                self.isEnabled = true
            case .outline:
                self.setTitleColor(UIColor(named: "brand colorgreen"), for: .normal)
                self.backgroundColor = UIColor(named: "grayscalegray1")
                self.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
                self.isEnabled = true
            case .cancel:
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = UIColor(named: "grayscalegray1")
                self.backgroundColor = .lightGray
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.isEnabled = true
            case .disable:
                self.setTitleColor(UIColor(named: "grayscalegray3"), for: .normal)
                self.backgroundColor = UIColor(named: "grayscalegray6")
                self.layer.borderColor = UIColor(named: "grayscalegray6")?.cgColor
//                self.isEnabled = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUp() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.stateOfButton = .disable
    }
}
