//
//  ErrorableRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/5/23.
//

import Foundation

protocol ErrorableRow: FormInputItemProtocol {
    func makeDirty()
}
