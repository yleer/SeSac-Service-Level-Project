//
//  HomeView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import MapKit
import SnapKit

enum HomeViewGenerSelection {
    case all
    case male
    case female
}

class HomeView: UIView {
    let mapView = MKMapView()
    
    let buttonsStack = UIStackView()
    let allButton = InActiveButton()
    let maleButton = InActiveButton()
    let femaleButton = InActiveButton()
    let bottomFloatingButton = UIButton()
    
    let currentLocationButton = InActiveButton()
    
    var selected = HomeViewGenerSelection.all {
        didSet {
            switch selected {
            case .all:
                allButton.stateOfButton = .fill
                maleButton.stateOfButton = .inActive
                femaleButton.stateOfButton = .inActive
            case .male:
                allButton.stateOfButton = .inActive
                maleButton.stateOfButton = .fill
                femaleButton.stateOfButton = .inActive
            case .female:
                allButton.stateOfButton = .inActive
                maleButton.stateOfButton = .inActive
                femaleButton.stateOfButton = .fill
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUp() {
        addSubview(mapView)
        addSubview(buttonsStack)
        addSubview(currentLocationButton)
        addSubview(bottomFloatingButton)
        setUpButtons()
            
        selected = .all
    }
    
    private func setUpButtons() {
        buttonsStack.addArrangedSubview(allButton)
        buttonsStack.addArrangedSubview(maleButton)
        buttonsStack.addArrangedSubview(femaleButton)
        
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 0
        allButton.setTitle("전체", for: .normal)
        maleButton.setTitle("남자", for: .normal)
        femaleButton.setTitle("여자", for: .normal)
        
        buttonsStack.distribution = .fillEqually
        
        allButton.layer.borderWidth = 0
        allButton.layer.cornerRadius = 5
        allButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        maleButton.layer.cornerRadius = 0
        maleButton.layer.borderWidth = 0
        
        femaleButton.layer.borderWidth = 0
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        currentLocationButton.setImage(UIImage(named: ImageNames.HomeViewController.search), for: .normal)
        currentLocationButton.stateOfButton = .inActive
     
        
        bottomFloatingButton.setImage(UIImage(named: ImageNames.HomeViewController.main_status_button), for: .normal)
        
    }
    
    func setUpConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(buttonsStack.snp.bottom).offset(8)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }
        
        bottomFloatingButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
