//
//  NoReviewVIew.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/09.
//

import UIKit
import SnapKit

class NoReviewVIew: UIView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setUpConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        addSubview(label)
        label.text = "리뷰가 없습니다"
    }
    
    func setUpConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
