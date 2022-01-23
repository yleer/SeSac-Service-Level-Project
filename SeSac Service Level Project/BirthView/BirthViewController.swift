//
//  BirthViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit

class BirthViewController: UIViewController {
    
    let mainView = BirthView()
    let viewModel = BirthViewModel()
    
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
        if let dateString = UserDefaults.standard.string(forKey: "age") {
            let a = dateString[0]! + dateString[1]! + dateString[2]! + dateString[3]! + dateString[4]! + dateString[5]! + dateString[6]! + dateString[7]! + dateString[8]! + dateString[9]!
            
            mainView.datePickerView.datePicker.setDate(a.toDate()!, animated: true)
            mainView.toNextButon.stateOfButton = .fill
            
            viewModel.bornYear.value = dateString[0]! + dateString[1]! + dateString[2]! + dateString[3]!
            viewModel.bornMonth.value = dateString[5]! + dateString[6]!
            viewModel.bornDay.value = dateString[8]! + dateString[9]!
            viewModel.bornDate.value = a.toDate()!
            viewModel.updateDate()
        }
    }
    
    func binding() {
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
    
    func addTargets() {
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
    
    @objc func toNextButtonClicked(_ sender: UIButton) {
        if viewModel.allowed {
            let vc = EmailViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertVC = UIAlertController(title: "만 17 이하는 사용할 수 없습니다", message: "18세 이상이 되었을때 이용해주세요", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertVC.addAction(cancelButton)
            present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    @objc func hideDatePicker() {
        mainView.datePickerView.isHidden = true
    }
    
    @objc func targetViewDidTapped() {
        if mainView.datePickerView.isHidden {
            mainView.datePickerView.isHidden = false
        }else{
            mainView.datePickerView.isHidden = true
        }
    }
    
    @objc func selectedDate(_ sender: UIDatePicker) {
        viewModel.bornDate.value = sender.date
        let state = viewModel.updateDate()
        mainView.toNextButon.stateOfButton = state
    }
    
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
            
        } else {
            return nil
            
        }
        
    }
    
}

