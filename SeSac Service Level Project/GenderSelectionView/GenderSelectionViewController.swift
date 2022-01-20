//
//  GenderSelectionViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit

class GenderSelectionViewController: UIViewController {
    
    let viewModel = GenderSelectionViewModel()
    let mainView = GenderSelectionView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindings()
        addTargets()
        
    }
    
    func bindings() {
//        viewModel.phoneNumber.bind { text in
//            self.mainView.phoneNumberView.textField.text = text
//        }
//        viewModel.selectedGender.bind { gender in
//            <#code#>
//        }
        
    }
    
    func addTargets() {
        let maleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnMaleView))
        maleGesture.numberOfTapsRequired = 1
        
        let femaleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnFemaleView))
        femaleGesture.numberOfTapsRequired = 1
        
        mainView.maleButton.isUserInteractionEnabled = true
        mainView.femaleButton.isUserInteractionEnabled = true
        
        mainView.maleButton.addGestureRecognizer(maleGesture)
        mainView.femaleButton.addGestureRecognizer(femaleGesture)
    
        mainView.toNextButton.addTarget(self, action: #selector(toNextbuttonClicked), for: .touchUpInside)
    }
    
    @objc func tapOnFemaleView() {
        viewModel.selectedGender.value = 0
        mainView.femaleButton.backgroundColor = UIColor(named: "brand colorgreen")
        mainView.maleButton.backgroundColor = .white
        mainView.femaleButton.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
        mainView.maleButton.layer.borderColor = UIColor(named: "grayscalegray3")?.cgColor
        
        mainView.toNextButton.stateOfButton = .fill
        
    }
    
    @objc func tapOnMaleView() {
        viewModel.selectedGender.value = 1
        mainView.femaleButton.backgroundColor = .white
        mainView.maleButton.backgroundColor = UIColor(named: "brand colorgreen")
        mainView.femaleButton.layer.borderColor = UIColor(named: "grayscalegray3")?.cgColor
        mainView.maleButton.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
        mainView.toNextButton.stateOfButton = .fill
    }
    
    
    
    @objc func toNextbuttonClicked() {
        // 내일
    }
    
}
