//
//  GettableRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/4/23.
//

import Foundation

protocol GettableRow: Identifiable {
    func getValue() -> FormAnyInputValue?
}

extension GettableRow {
    var keyValuePair: KeyValuePairs {
        let value = getValue()
        return [key: value]
    }
}
