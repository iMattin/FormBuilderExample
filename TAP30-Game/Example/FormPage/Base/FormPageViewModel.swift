//
//  FormPageViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import Foundation
import Combine

class FormPageViewModel: FormPageViewModelProtocol, FormDelegate {
    lazy var focusedIndexPublisher: AnyPublisher<Int?, Never> = {
        _focusedIndex.eraseToAnyPublisher()
    }()

    lazy var fieldsPublisher: AnyPublisher<[FormField], Never> = {
        _fields.eraseToAnyPublisher()
    }()

    private var _fields = PassthroughSubject<[FormField], Never>()
    private var _focusedIndex = PassthroughSubject<Int?, Never>()

    let form = Form(fields: [])

    var formItems: [FormInputItemProtocol] {
        form.allInputItems
    }

    init() {
        form.delegate = self
    }

    func viewDidLoad() {
        _fields.send(form.fields)
    }

    func set(fields: [FormField]) {
        form.set(fields: fields)
        _fields.send(form.fields)
    }

    func valueHasBeenChanged<Value: Equatable>(_ form: Form, item: FormInputItem<Value>, oldValue: Value?, newValue: Value?) {
    }

    func validateForm() {
        var invalidRowIndex: Int?
        for (index, field) in form.fields.enumerated() {
            guard let row = field.type.inputItem as? (ErrorableRow) else { continue }
            row.makeDirty()
            if invalidRowIndex == nil && row.status == .invalid {
                invalidRowIndex = index
            }
        }
        self._focusedIndex.send(invalidRowIndex)
    }
    
}

