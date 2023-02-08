//
//  ScreenRowViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 2/7/23.
//

import Foundation
import Combine

protocol ScreenRowViewModelDelegate: AnyObject {
    func screenRowViewModel(_ viewModel: ScreenRowViewModel, widgets: [Widget], preset data: KeyValuePairs?)
}

class ScreenRowViewModel: BaseFormItemViewModel<KeyValuePairs>, SelectorViewModelProtocol, ValuableRow {

    weak var delegate: ScreenRowViewModelDelegate?

    let widget: Widgets_ScreenData

    init(widget: Widgets_ScreenData) {
        self.widget = widget
        super.init(key: widget.key)
        add(validator: RequiredValidator(message: "Required message", onExecution: { [weak self] isValid in
            self?.rowMessage = isValid ? nil : .error("this field is required")
        }))
    }

    lazy var titlePublisher: AnyPublisher<String, Never> = {
        valueChanges.map { [weak self] model -> String in
            "\(model?.count ?? 0) filled items"
        }.eraseToAnyPublisher()
    }()

    lazy var isEnabledPublisher: AnyPublisher<Bool, Never> = {
        statusChanges.map { $0 != .disabled }.eraseToAnyPublisher()
    }()

    func getValue() -> FormAnyInputValue? {
        guard let keyPairs = value else { return nil }
        return .nested(values: keyPairs)
    }

    func setValue(_ value: FormAnyInputValue?) {
        guard var keyValue = value?.nested else { return }
        if let currentValue = self.value {
            keyValue = keyValue.merging(currentValue, uniquingKeysWith: { a, _ in a })
        }
        setValue(keyValue, onlySelf: false)
    }

    func select() {
        delegate?.screenRowViewModel(self, widgets: widget.widgets, preset: value)
    }
}
