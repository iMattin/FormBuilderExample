//
//  ResizableFormRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

protocol ResizableFormRow {
    typealias OnRowHeightChange = (_ forceReload: Bool, _ animated: Bool) -> Void

    func register(onRowHeightChange: @escaping OnRowHeightChange)
}
