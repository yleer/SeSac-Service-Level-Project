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
       self.sectionInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0.0, right: 30)
       
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
//"<SnapKit.LayoutConstraint:0x6000022efc00@SizingCell.swift#71 UILabel:0x7fee631bda10.height == 32.0>",
//"<SnapKit.LayoutConstraint:0x6000022edc20@SizingCell.swift#74 UILabel:0x7fee631bda10.top == UIView:0x7fee631c5600.top + 5.0>",
//"<SnapKit.LayoutConstraint:0x6000022eff60@SizingCell.swift#75 UILabel:0x7fee631bda10.bottom == UIView:0x7fee631c5600.bottom - 5.0>",
//"<NSLayoutConstraint:0x6000025b31b0 'UIView-Encapsulated-Layout-Height' UIView:0x7fee631c5600.height == 50   (active)>"
class HobbySearchView: UIView {
    
    let findFreindsButton = InActiveButton()
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
//        layout.estimatedItemSize = CGSize(width: UICollectionViewFlowLayout.automaticSize.width, height: 32)
        
        
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
//        cv.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        cv.register(SizingCell.self, forCellWithReuseIdentifier: SizingCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpNormalConstraints()
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
        findFreindsButton.setTitle("새싹 찾기", for: .normal)
        findFreindsButton.stateOfButton = .fill
    }
    
    private func removeAllConstraints() {
        firstSection.snp.removeConstraints()
        collectionView.snp.removeConstraints()
        secondSection.snp.removeConstraints()
        secondCollectionView.snp.removeConstraints()
        findFreindsButton.snp.removeConstraints()
    }
    
    
    func setUpNormalConstraints() {
        removeAllConstraints()
        findFreindsButton.layer.cornerRadius = 10
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
            make.height.equalTo(120)
        }
        
        findFreindsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func setUpWhenKeyBoardConstraints(keyBoardHeight: CGFloat) {
        removeAllConstraints()
        findFreindsButton.layer.cornerRadius = 0
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
        bringSubviewToFront(findFreindsButton)
        findFreindsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-keyBoardHeight)
        }
    }
    
}
