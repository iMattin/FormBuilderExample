//
//  SelectorViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import Foundation
import Combine

protocol SelectorViewModelDelegate: AnyObject {
    func selector(_ viewModel: SelectorViewModel, didRequestSelectFrom items: [Widgets_SelectorData.SelectItem])
}

class SelectorViewModel: BaseFormItemViewModel<String>, SelectorViewModelProtocol, ValuableRow, ReloadableRow {

    weak var delegate: SelectorViewModelDelegate?

    let widget: Widgets_SelectorData
    lazy var titlePublisher: AnyPublisher<String, Never> = {
        valueChanges.map { [weak self] id -> String in
            self?.widget.items.first(where: { $0.id == id })?.title ?? "NOT SELECTED"
        }.eraseToAnyPublisher()
    }()

    lazy var isEnabledPublisher: AnyPublisher<Bool, Never> = {
        statusChanges.map { $0 != .disabled }.eraseToAnyPublisher()
    }()

    var shouldReload: Bool {
        true
    }

    init(widget: Widgets_SelectorData) {
        self.widget = widget
        super.init(key: widget.key, value: widget.defaultValue)

        add(validator: RequiredValidator(message: "Required!", onExecution: { [weak self] isValid in
            self?.rowMessage = isValid ? nil : .error("this field is required")
        }))
    }

    func select() {
        guard enabled else { return }
        delegate?.selector(self, didRequestSelectFrom: widget.items)
    }

    func getValue() -> FormAnyInputValue? {
        guard let id = value else { return nil }
        return .string(value: id)
    }

    func setValue(_ value: FormAnyInputValue?) {
        guard let value = value?.string, widget.items.contains(where: { $0.id == value }) else { return }
        setValue(value, onlySelf: false)
    }
}
