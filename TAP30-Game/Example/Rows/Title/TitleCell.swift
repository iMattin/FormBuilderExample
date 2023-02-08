//
//  TitleCell.swift
//  TAP30-Game
//
//  Created by Matin on 2/7/23.
//

import UIKit

class TitleCell: UICollectionViewCell {
    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.font = .systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(label)
        label.fillInSuperview(padding: .init(top: 8, leading: 16, bottom: 4, trailing: 16))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with title: String) {
        label.text = title
    }
}
