//
//  FormField.swift
//  TAP30-Game
//
//  Created by Matin on 2/5/23.
//

import Foundation
import Combine

enum FormFieldType {
    case valuable(_ item: FormInputItemProtocol)
    case displayable

    var inputItem: FormInputItemProtocol? {
        switch self {
        case .displayable: return nil
        case .valuable(let item): return item
        }
    }
}

protocol FormField: AnyObject {
    var type: FormFieldType { get }
}
