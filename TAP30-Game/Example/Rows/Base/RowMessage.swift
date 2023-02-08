//
//  RowMessage.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import Foundation

enum RowMessage {
    case error(_ message: String)
    case warning(_ message: String)
    case hint(_ message: String)

    var message: String {
        switch self {
        case .error(let msg), .hint(let msg), .warning(let msg):
            return msg
        }
    }
}
