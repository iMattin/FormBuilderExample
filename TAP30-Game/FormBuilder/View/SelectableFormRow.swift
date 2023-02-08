//
//  SelectableFormRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

protocol SelectableFormRow {
    func didSelectRow()
    func didLongPressRow()
}

extension SelectableFormRow {
    func didLongPressRow() {}
}
