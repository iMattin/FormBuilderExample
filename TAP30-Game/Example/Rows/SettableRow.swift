//
//  SettableRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/4/23.
//

import Foundation

protocol SettableRow: Identifiable {
    func setValue(_ value: FormAnyInputValue?)
}

