//
//  FormItem.swift
//  TAP30-Game
//
//  Created by Matin on 2/4/23.
//

import Foundation
import Combine

public enum ControlStatus {
    case valid
    case invalid
    case disabled
}

protocol FormInputItemDelegate: AnyObject {
    func resetStatus()
    func didChangeStatus<Value: Equatable>(_ item: FormInputItem<Value>)
    func didChangeValue<Value: Equatable>(_ item: FormInputItem<Value>, oldValue: Value?, newValue: Value?)
}

protocol FormInputItemProtocol: AnyObject {
    var status: ControlStatus? { get }
    var parentDelegate: FormInputItemDelegate? { get set }

    func disable(onlySelf: Bool)
    func enable(onlySelf: Bool)
}

class FormInputItem<Value: Equatable>: FormInputItemProtocol {
    weak var parentDelegate: FormInputItemDelegate?

    var value: Value? {
        _value
    }

    lazy var valueChanges = $_value.eraseToAnyPublisher()

    var status: ControlStatus? {
        _status
    }

    lazy var statusChanges = $_status.eraseToAnyPublisher()

    var isDirty: Bool {
        get {
            _isDirty
        }
        set {
            _isDirty = newValue
        }
    }

    lazy var dirtyChanges = $_isDirty.eraseToAnyPublisher()

    var valid: Bool {
        return _status == .valid
    }

    var enabled: Bool {
        return _status != .disabled
    }

    var disabled: Bool {
        return _status == .disabled
    }

    @Published private var _value: Value?
    @Published private var _status: ControlStatus?
    @Published private var _errors: [String] = []
    @Published private var _isDirty: Bool = false

    private var _validators: [ValidationHelper<Value>] = []

    init(value: Value?) {
        _value = value
        updateValidity()
    }

    func updateValidity(onlySelf: Bool = true) {
        if enabled {
            _errors = _validators.compactMap { $0.validateFn(_value)?.message }
            _status = calculateStatus()
        }

        if !onlySelf {
            parentDelegate?.didChangeStatus(self)
        }
    }

    func setValidators<V: FormValidator>(_ validators: [V]) where V.Value == Value {
        _validators = validators.map {
            .init(validateFn: $0.validate(_:), validator: $0)
        }

        updateValidity()
    }

    func add<V: FormValidator>(validator: V) where V.Value == Value {
        _validators.append(.init(validateFn: { n in
            validator.validate(n)
        }, validator: validator))

        updateValidity()
    }

    func enable(onlySelf: Bool = false) {
        _status = nil
        if !onlySelf {
            parentDelegate?.resetStatus()
        }

        updateValidity(onlySelf: onlySelf)
    }

    func disable(onlySelf: Bool = false) {
        _status = .disabled
        updateValidity(onlySelf: onlySelf)
    }

    func setValue(_ value: Value?, onlySelf: Bool = false) {
        let oldValue = _value
        _value = value
        updateValidity()
        _isDirty = true
        if !onlySelf {
            parentDelegate?.didChangeValue(self, oldValue: oldValue, newValue: value)
        }
    }

    func calculateStatus() -> ControlStatus {
        guard _errors.isEmpty else { return .invalid }
        return .valid
    }
}
