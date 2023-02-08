//
//  TextFieldViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import Foundation
import Combine

protocol TextFieldViewModelProtcol: AnyObject {
    var textPublisher: AnyPublisher<String?, Never> { get }
    var isEnabledPublisher: AnyPublisher<Bool, Never> { get }

    func update(text: String?)
}

class TextFieldViewModel: BaseFormItemViewModel<String>, TextFieldViewModelProtcol, ValuableRow {

    lazy var textPublisher: AnyPublisher<String?, Never> = {
        valueChanges.eraseToAnyPublisher()
    }()

    lazy var isEnabledPublisher: AnyPublisher<Bool, Never> = {
        statusChanges.map { $0 != .disabled }.eraseToAnyPublisher()
    }()

    init(widget: Widgets_TextFieldData) {
        super.init(key: widget.key, value: widget.defaultValue, defaultMessage: nil)
        widget.isEnabled ? enable() : disable()
        addRequiredValidator()
    }

    func update(text: String?) {
        setValue(text)
        if text == "1" { disable() }
    }

    func getValue() -> FormAnyInputValue? {
        guard let id = value else { return nil }
        return .string(value: id)
    }

    func setValue(_ value: FormAnyInputValue?) {
        setValue(value?.string, onlySelf: false)
    }
}
