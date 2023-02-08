//
//  DivierCell.swift
//  TAP30-Game
//
//  Created by Matin on 2/4/23.
//

import UIKit

class DividerCell: UICollectionViewCell {

    lazy var lineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        lineView.backgroundColor = .systemGray5
        contentView.addSubview(lineView)
        lineView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
