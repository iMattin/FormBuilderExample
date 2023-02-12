//
//  Strategies.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

struct SubmitStrategy: StickyFormPageSubmitStrategy {
    func onSubmit(_ fields: [FormField], completion: @escaping SubmitCompletion) -> StickyFormPageStatus {
        let dics = fields.compactMap { $0.type.inputItem }.compactMap {
            $0 as? GettableRow
        }.map { $0.keyValuePair }

        let json = try! JSONEncoder().encode(dics)
        print(json.prettyPrintedJSONString!)

        completion(.reload([
            AppFormField(field: .customTitle("DONE ✅"))
        ]))
        return .none
    }
}

struct ValueChangeStrategy: StickyFormPageValueChangeStrategy {
    func onValueChange<Value>(_ item: FormInputItem<Value>, _ fields: [FormField], completion: @escaping SubmitCompletion) -> StickyFormPageStatus where Value : Equatable {
        guard let textInput = item as? TextFieldViewModel, textInput.key == "field1" else { return .none }
        let screen = fields.compactMap { $0.type.inputItem }.compactMap { $0 as? SettableRow }.first(where: { $0.key == "screen1" })
        screen?.setValue(.nested(values: [
            "screen2": .nested(values: [
                "innter_field1": .string(value: textInput.value ?? "")
            ])
        ]))
        completion(.none)
        return .none
    }
}

struct ScreenSubmitStrategy: StickyFormPageSubmitStrategy {
    let submitClosure: ([KeyValuePairs]) -> Void

    func onSubmit(_ fields: [FormField], completion: @escaping SubmitCompletion) -> StickyFormPageStatus {
        let dics = fields.compactMap { $0.type.inputItem }.compactMap {
            $0 as? GettableRow
        }.map { $0.keyValuePair }
        submitClosure(dics)
        completion(.none)
        return .none
    }
}
