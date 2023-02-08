//
//  Validators.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import Foundation

struct FormValidationResult {
    let message: String?
}

protocol FormValidator<Value> {
    associatedtype Value: Equatable

    func validate(_ value: Value?) -> FormValidationResult?
}

public struct ValidationHelper<T: Equatable> {
    let validateFn: ((T?) -> FormValidationResult?)
    let validator: any FormValidator
}

struct RequiredValidator<T: Equatable>: FormValidator {

    let message: String
    let onExecution: ((_ isValid: Bool) -> Void)?

    func validate(_ value: T?) -> FormValidationResult? {
        var result: FormValidationResult?
        if let str = value as? String {
            result = str.isEmpty ? .init(message: message) : nil
        } else {
            result = value == nil ? .init(message: message) : nil
        }
        onExecution?(result == nil)
        return result
    }
}
