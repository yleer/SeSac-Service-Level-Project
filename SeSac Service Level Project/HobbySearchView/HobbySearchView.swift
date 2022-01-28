//
//  HobbySearchView.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/27.
//

import UIKit
import SnapKit




class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
   let cellSpacing: CGFloat = 8

   override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       self.minimumLineSpacing = 8
       self.sectionInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0.0, right: 100)
       
       let attributes = super.layoutAttributesForElements(in: rect)

       var leftMargin = sectionInset.left
       var maxY: CGFloat = -1.0
       attributes?.forEach { layoutAttribute in
           if layoutAttribute.frame.origin.y >= maxY {
               leftMargin = sectionInset.left
           }
           layoutAttribute.frame.origin.x = leftMargin
           leftMargin += layoutAttribute.frame.width + cellSpacing
           maxY = max(layoutAttribute.frame.maxY, maxY)
       }
       return attributes
   }
}

class HobbySearchView: UIView {
    
    let findFreindsButton = UIButton()
    let firstSection = UILabel()
    let secondSection = UILabel()
    let collectionView : UICollectionView = {
       
        let layout = CollectionViewLeftAlignFlowLayout()
//        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        cv.register(SizingCell.self, forCellWithReuseIdentifier: SizingCell.identifier)
        return cv
    }()
    
    let secondCollectionView: UICollectionView = {
        
        let layout = CollectionViewLeftAlignFlowLayout()
//        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        cv.register(SizingCell.self, forCellWithReuseIdentifier: SizingCell.identifier)
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
    func setUp() {
        addSubview(secondSection)
        addSubview(firstSection)
        addSubview(collectionView)
        addSubview(findFreindsButton)
        addSubview(secondCollectionView)
        
        backgroundColor = .white
        
        firstSection.font = UIFont(name: FontNames.regular, size: 12)
        firstSection.text = "지금 주변에는"
        secondSection.font = UIFont(name: FontNames.regular, size: 12)
        secondSection.text = "내가 하고 싶은"
    }
    
    func setUpConstraints() {
        firstSection.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
            make.height.equalTo(18)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(firstSection.snp.bottom).offset(16)
            make.height.equalTo(150)
        }
        
        secondSection.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.height.equalTo(18)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        
        secondCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(secondSection.snp.bottom).offset(16)
            make.height.equalTo(150)
        }
    }
    
}
