//
//  ReloadableRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/7/23.
//

import Foundation

protocol ReloadableRow: Identifiable {
    var shouldReload: Bool { get }
}
