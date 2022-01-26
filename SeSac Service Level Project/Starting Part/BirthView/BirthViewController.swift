//
//  BirthViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import Toast

class BirthViewController: UIViewController {
    
    private let mainView = BirthView()
    private let viewModel = BirthViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let date = viewModel.checkForPreiousData(){
            mainView.datePickerView.datePicker.setDate(date, animated: true)
            mainView.toNextButon.stateOfButton = .fill
        }
    }
    
    private func binding() {
        viewModel.bornYear.bind { text in
            self.mainView.birthLabelView.bornYearLabel.text = text
        }
        
        viewModel.bornMonth.bind { text in
            self.mainView.birthLabelView.bornMonthLabel.text = text
        }
        
        viewModel.bornDay.bind { text in
            self.mainView.birthLabelView.borndayLabel.text = text
        }
    }
    
    private func addTargets() {
        mainView.datePickerView.datePicker.addTarget(self, action: #selector(selectedDate), for: .valueChanged)
        mainView.toNextButon.addTarget(self, action: #selector(toNextButtonClicked), for: .touchUpInside)
        
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetViewDidTapped))
        gesture.numberOfTapsRequired = 1
        mainView.birthLabelView.isUserInteractionEnabled = true
        mainView.birthLabelView.addGestureRecognizer(gesture)
        
        
        let hideGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideDatePicker))
        hideGesture.numberOfTapsRequired = 1
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(hideGesture)
    }
    
    @objc private func toNextButtonClicked(_ sender: UIButton) {
        if viewModel.allowed {
            navigationController?.pushViewController(EmailViewController(), animated: true)
        } else {
            
            self.view.makeToast(ToastMessage.notValidAge.rawValue)
        }
    }
    
    @objc private func hideDatePicker() {
        mainView.datePickerView.isHidden = true
    }
    
    @objc private func targetViewDidTapped() {
        if mainView.datePickerView.isHidden {
            mainView.datePickerView.isHidden = false
        }else{
            mainView.datePickerView.isHidden = true
        }
    }
    
    @objc private func selectedDate(_ sender: UIDatePicker) {
        viewModel.bornDate.value = sender.date
        let state = viewModel.updateDate()
        mainView.toNextButon.stateOfButton = state
    }
}



