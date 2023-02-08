//
//  BaseFormRow.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import UIKit

class BaseFormRow: RenderableFormRow {

    typealias Decoratee = (any RenderableFormRow)

    var identifier: String {
        _decoratee.identifier
    }

    private let _decoratee: Decoratee
    private let _viewModel: BaseViewModelProtocol
    private var heightChange: ResizableFormRow.OnRowHeightChange?

    init(decoratee: Decoratee, viewModel: BaseViewModelProtocol) {
        _decoratee = decoratee
        _viewModel = viewModel
    }

    func registerCell(in renderer: FormRendererViewController) {
        _decoratee.registerCell(in: renderer)
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _decoratee.renderCell(with: renderer, at: indexPath)
        if let configurable = cell as? BaseCellConfiguarable {
            configurable.contentDelegate = self
            configurable.configure(with: _viewModel)
        }
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        let extraHeight = _viewModel.hasFooter ? 30.0 : 0
        return _decoratee.calculateCellHeight(renderer) + extraHeight
    }
}

extension BaseFormRow: BaseCellDelegate {
    func cellDidChangeContent<EmbeddedView: UIView>(_ cell: BaseCell<EmbeddedView>) {
        heightChange?(false, true)
    }
}

extension BaseFormRow: ResizableFormRow {
    func register(onRowHeightChange: @escaping ResizableFormRow.OnRowHeightChange) {
        self.heightChange = onRowHeightChange
        if let resizable = _decoratee as? ResizableFormRow {
            resizable.register(onRowHeightChange: onRowHeightChange)
        }
    }
}

extension BaseFormRow: SelectableFormRow {
    func didSelectRow() {
        (_decoratee as? SelectableFormRow)?.didSelectRow()
    }

    func didLongPressRow() {
        (_decoratee as? SelectableFormRow)?.didLongPressRow()
    }
}
