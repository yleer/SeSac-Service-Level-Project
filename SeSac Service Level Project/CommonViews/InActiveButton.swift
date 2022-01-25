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
                self.layer.borderColor = UIColor(named: ColorNames.gray4)?.cgColor
                self.isEnabled = true
            case .fill:
                self.setTitleColor(.white, for: .normal)
                self.backgroundColor = UIColor(named: ColorNames.brandGreen)
                self.layer.borderColor = UIColor(named: ColorNames.brandGreen)?.cgColor
                self.isEnabled = true
            case .outline:
                self.setTitleColor(UIColor(named: ColorNames.brandGreen), for: .normal)
                self.backgroundColor = UIColor(named: ColorNames.gray1)
                self.layer.borderColor = UIColor(named: ColorNames.brandGreen)?.cgColor
                self.isEnabled = true
            case .cancel:
                self.setTitleColor(.black, for: .normal)
                self.backgroundColor = UIColor(named: ColorNames.gray1)
                self.backgroundColor = .lightGray
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.isEnabled = true
            case .disable:
                self.setTitleColor(UIColor(named: ColorNames.gray3), for: .normal)
                self.backgroundColor = UIColor(named: ColorNames.gray6)
                self.layer.borderColor = UIColor(named: ColorNames.gray6)?.cgColor
                self.isEnabled = false
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
        self.stateOfButton = .cancel
        self.titleLabel?.font = UIFont(name: FontNames.regular, size: 14)
    }
}




