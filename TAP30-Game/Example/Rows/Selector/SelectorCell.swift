//
//  SelectorCell.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import UIKit
import Combine

protocol SelectorViewModelProtocol: AnyObject {
    var titlePublisher: AnyPublisher<String, Never> { get }
    var isEnabledPublisher: AnyPublisher<Bool, Never> { get }
    
    func select()
}

class SelectorView: UIView {
    lazy var titleLabel = UILabel()
    private lazy var indicator = UIImageView(image: .init(systemName: "chevron.right"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        indicator.widthAnchor.constraint(equalToConstant: 12).isActive = true

        let stackVeiw = UIStackView()
        stackVeiw.axis = .horizontal
        stackVeiw.addArrangedSubview(titleLabel)
        stackVeiw.addArrangedSubview(indicator)

        addSubview(stackVeiw)
        stackVeiw.fillInSuperview(padding: .init(top: 8, leading: 4, bottom: 8, trailing: 4))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

class SelectorCell: BaseCell<SelectorView> {
    var viewModel: SelectorViewModelProtocol?
    private var store = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with viewModel: SelectorViewModelProtocol) {
        store = .init()
        self.viewModel = viewModel

        viewModel.titlePublisher.sink { [weak self] title in
            self?.embeddedView.titleLabel.text = title
        }.store(in: &store)

        viewModel.isEnabledPublisher.sink { [weak self] isEnabled in
            self?.embeddedView.titleLabel.textColor = isEnabled ? .black : .systemGray4
        }.store(in: &store)
    }
}
