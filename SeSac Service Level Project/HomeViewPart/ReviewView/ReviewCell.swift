//
//  ReviewCell.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/09.
//

import UIKit
import SnapKit


class ReviewCell: UITableViewCell {
    
    static let identifier = "ReviewCell"

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
