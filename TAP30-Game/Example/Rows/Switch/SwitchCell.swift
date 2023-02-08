//
//  SwitchCell.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit
import Combine

class SwitchCell: UICollectionViewCell {
    var viewModel: SwitchViewModelProtcol?
    private var store = Set<AnyCancellable>()

    private lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(onValueChange), for: .valueChanged)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.addArrangedSubview(switchView)
        stackView.addArrangedSubview(titleLabel)

        contentView.addSubview(stackView)
        stackView.fillInSuperview(padding: .init(top: 4, leading: 12, bottom: 4, trailing: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with viewModel: SwitchViewModelProtcol) {
        store = .init()
        self.viewModel = viewModel

        viewModel.titlePublisher.sink { [weak self] title in
            self?.titleLabel.text = title
        }.store(in: &store)

        viewModel.isOnPublisher.sink { [weak self] isOn in
            self?.switchView.isOn = isOn
        }.store(in: &store)
    }

    @objc func onValueChange() {
        viewModel?.update(isOn: switchView.isOn)
    }
}
