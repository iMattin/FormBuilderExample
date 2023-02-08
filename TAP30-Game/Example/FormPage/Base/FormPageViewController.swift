//
//  FormPageViewController.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit
import Combine

protocol FormPageViewModelProtocol {
    // Outputs
    var fieldsPublisher: AnyPublisher<[FormField], Never> { get }
    var focusedIndexPublisher: AnyPublisher<Int?, Never> { get }

    func viewDidLoad()
}

protocol FormPageViewControllerRowGenerator {
    func generateRow(_ vc: FormPageViewController, with field: FormField) -> any RenderableFormRow
}

class FormPageViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()

    private let generator: FormPageViewControllerRowGenerator
    private let viewModel: FormPageViewModelProtocol

    lazy var renderer: FormRendererViewController = {
        let returnValue = FormRendererViewController()
        return returnValue
    }()

    init(viewModel: FormPageViewModelProtocol, generator: FormPageViewControllerRowGenerator) {
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

        renderer.willMove(toParent: self)
        addChild(renderer)
        view.addSubview(renderer.view)
        renderer.view.fillInSuperview()
        renderer.didMove(toParent: self)

        bindViewModel()
        viewModel.viewDidLoad()
    }

    private func bindViewModel() {
        viewModel.fieldsPublisher.sink { [unowned self] fields in
            let rows = fields.map { self.generator.generateRow(self, with: $0) }
            self.renderer.rows = rows
        }.store(in: &cancellables)

        viewModel.focusedIndexPublisher.sink { [unowned self] index in
            guard let index else { return }
            self.renderer.collectionView.selectItem(at: .init(row: index, section: 0),
                                                    animated: true,
                                                    scrollPosition: .centeredVertically)
        }.store(in: &cancellables)
    }
}
