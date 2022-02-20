//
//  SeSacPurchaseView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit

final class SeSacPurchaseView: UIView {
    
    let collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
    
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 25
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        cv.register(SesacCollectionViewCell.self, forCellWithReuseIdentifier: SesacCollectionViewCell.identifier)
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        collectionView.snp.makeConstraints { make in
            
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20).priority(750)
            make.bottom.equalToSuperview().priority(750)
        }
    }
    
}
