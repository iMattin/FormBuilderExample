//
//  BaseCell.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import UIKit
import Combine

protocol BaseViewModelProtocol {
    var message$: AnyPublisher<RowMessage?, Never> { get }
    var moreInfo$: AnyPublisher<String?, Never> { get }
    var showFooter$: AnyPublisher<Bool, Never> { get }
    var hasFooter: Bool { get }

    func onMoreInfoClicked()
}

extension BaseViewModelProtocol {
    var footerVisibility$: AnyPublisher<Bool, Never> {
        showFooter$.combineLatest(message$, moreInfo$)
            .map { (showFooter, message, moreInfo) in
                showFooter && (message != nil || moreInfo != nil)
            }.eraseToAnyPublisher()
    }
}

protocol BaseCellConfiguarable: AnyObject {
    var contentDelegate: BaseCellDelegate? { get set }
    func configure(with viewModel: BaseViewModelProtocol)
}

protocol BaseCellDelegate: AnyObject {
    func cellDidChangeContent<EmbeddedView: UIView>(_ cell: BaseCell<EmbeddedView>)
}

class BaseCell<EmbeddedView: UIView>: UICollectionViewCell, BaseCellConfiguarable {

    weak var contentDelegate: BaseCellDelegate?

    private var baseViewModel: BaseViewModelProtocol?
    private var store = Set<AnyCancellable>()

    var message: RowMessage? {
        didSet {
            messageLabel.text = message?.message
            switch message {
            case .warning:
                messageLabel.textColor = .yellow
            case .error:
                messageLabel.textColor = .red
            case .hint, .none:
                messageLabel.textColor = .gray
            }
        }
    }

    lazy var embeddedView: EmbeddedView = EmbeddedView()

    lazy var footerView = {
        let view = UIView()
        view.backgroundColor = .red
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()

    lazy var messageLabel = {
        let label = UILabel()
        return label
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupStackView()
        footerView.backgroundColor = .clear
        let footerStackView = UIStackView()
        footerStackView.axis = .horizontal
        footerStackView.distribution = .fillEqually
        footerStackView.addArrangedSubview(messageLabel)
        footerView.addSubview(footerStackView)
        footerStackView.fillInSuperview(padding: .init(top: 4, leading: 4, bottom: 4, trailing: 4))

        stackView.addArrangedSubview(embeddedView)
        stackView.addArrangedSubview(footerView)
    }

    private func setupStackView() {
        stackView.spacing = 0
        contentView.addSubview(stackView)
        stackView.fillInSuperview(padding: .init(top: 4, leading: 12, bottom: 4, trailing: 12))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with viewModel: BaseViewModelProtocol) {
        self.baseViewModel = viewModel
        setupBinding()
    }

    private func setupBinding() {
        store = .init()
        guard let viewModel = baseViewModel else { return }
        viewModel.message$
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.message = message
            }.store(in: &store)

        viewModel.footerVisibility$
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFooterVisible in
                guard let self else { return }
                self.footerView.isHidden = !isFooterVisible
                self.contentDelegate?.cellDidChangeContent(self)
            }.store(in: &store)
    }
}
