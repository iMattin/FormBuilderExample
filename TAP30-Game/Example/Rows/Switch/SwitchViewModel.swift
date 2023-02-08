//
//  SwitchViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import Foundation
import Combine

protocol SwitchViewModelProtcol: AnyObject {
    var isOnPublisher: AnyPublisher<Bool, Never> { get set }
    var titlePublisher: AnyPublisher<String?, Never> { get }

    func update(isOn: Bool)
}

class SwitchViewModel: FormInputItem<Bool>, SwitchViewModelProtcol, Identifiable, ValuableRow {
    let key: String

    lazy var titlePublisher: AnyPublisher<String?, Never> = {
        valueChanges.map { $0 ?? false ? "ON" : "OFF" }.eraseToAnyPublisher()
    }()

    lazy var isOnPublisher: AnyPublisher<Bool, Never> = {
        valueChanges.map { $0 ?? false }.eraseToAnyPublisher()
    }()

    init(widget: Widgets_CheckboxData) {
        self.key = widget.key
        super.init(value: widget.defaultValue)
    }

    func update(isOn: Bool) {
        setValue(isOn, onlySelf: false)
    }

    func getValue() -> FormAnyInputValue? {
        .boolean(value: value ?? false)
    }

    func setValue(_ value: FormAnyInputValue?) {
        setValue(value?.boolean, onlySelf: false)
    }
}
