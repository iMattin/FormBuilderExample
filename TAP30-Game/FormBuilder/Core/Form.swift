//
//  Form.swift
//  TAP30-Game
//
//  Created by Matin on 2/1/23.
//

import Foundation

protocol FormDelegate: AnyObject {
    func valueHasBeenChanged<Value: Equatable>(_ form: Form, item: FormInputItem<Value>, oldValue: Value?, newValue: Value?)
}

final class Form {

    weak var delegate: FormDelegate?

    var status: ControlStatus? {
        _status
    }

    lazy var statusChanges = $_status.eraseToAnyPublisher()

    var valid: Bool {
        return _status == .valid
    }

    var enabled: Bool {
        return _status != .disabled
    }

    var disabled: Bool {
        return _status == .disabled
    }

    @Published private var _status: ControlStatus?
    private(set) var fields: [FormField] = []

    var allInputItems: [FormInputItemProtocol] {
        fields.compactMap { $0.type.inputItem }
    }

    var allValidItems: [FormInputItemProtocol] {
        allInputItems.filter { $0.status == .valid }
    }

    init(fields: [FormField] = []) {
        setAndConfigure(fields: fields)
    }

    func set(fields: [FormField]) {
        setAndConfigure(fields: fields)
    }

    func updateValidity() {
        if enabled {
            _status = calculateStatus()
        }
    }

    func enable() {
        allInputItems.forEach { $0.enable(onlySelf: true) }
        _status = nil
        updateValidity()
    }

    func disable() {
        allInputItems.forEach { $0.disable(onlySelf: true) }
        _status = .disabled
    }

    func calculateStatus() -> ControlStatus {
        if areAllItemsDisabled() { return .disabled }
        if anyItemHasStatus(.invalid) { return .invalid }
        return .valid
    }

    private func areAllItemsDisabled() -> Bool {
        for item in allInputItems {
            if item.status != .disabled { return false }
        }
        return true
    }

    private func anyItemHasStatus(_ status: ControlStatus) -> Bool {
        for item in allInputItems {
            if item.status == status { return true }
        }
        return false
    }

    private func setAndConfigure(fields: [FormField]) {
        _status = nil
        self.fields = fields
        allInputItems.forEach { $0.parentDelegate = self }
        updateValidity()
    }
}

extension Form: FormInputItemDelegate {
    func resetStatus() {
        _status = nil
    }

    func didChangeStatus<Value>(_ item: FormInputItem<Value>) where Value : Equatable {
        updateValidity()
    }

    func didChangeValue<Value>(_ item: FormInputItem<Value>, oldValue: Value?, newValue: Value?) where Value : Equatable {
        updateValidity()
        delegate?.valueHasBeenChanged(self, item: item, oldValue: oldValue, newValue: newValue)
    }
}
