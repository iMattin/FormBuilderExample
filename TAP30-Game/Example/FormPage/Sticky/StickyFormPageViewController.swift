//
//  StickyFormPageViewController.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import UIKit
import Combine

protocol StickyFormPageViewModelProtocol: FormPageViewModelProtocol {
    var stickyTitlePublisher: AnyPublisher<String, Never> { get }
    var statusPublisher: AnyPublisher<StickyFormPageStatus, Never> { get }
    
    func submit()
}

class StickyFormPageViewController: UIViewController {

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var formPageViewController: FormPageViewController = {
        let vc = FormPageViewController(viewModel: viewModel, generator: generator)
        return vc
    }()

    private lazy var stickyButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.4), for: .highlighted)
        button.addTarget(self, action: #selector(didTapOnStickyButton), for: .touchUpInside)
        button.backgroundColor = .systemFill
        return button
    }()

    private let viewModel: StickyFormPageViewModelProtocol
    private let generator: FormPageViewControllerRowGenerator
    private var store = Set<AnyCancellable>()

    init(viewModel: StickyFormPageViewModelProtocol, generator: FormPageViewControllerRowGenerator) {
        self.viewModel = viewModel
        self.generator = generator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(mainStackView)
        mainStackView.fillInSuperview()

        mainStackView.addArrangedSubview(formPageViewController.view)
        mainStackView.addArrangedSubview(stickyButton)

        viewModel.stickyTitlePublisher.sink { [unowned self] title in
            self.stickyButton.setTitle(title, for: .normal)
        }.store(in: &store)
    }

    @objc func didTapOnStickyButton() {
        viewModel.submit()
    }
}
