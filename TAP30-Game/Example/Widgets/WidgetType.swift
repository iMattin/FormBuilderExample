//
//  WidgetType.swift
//  TAP30-Game
//
//  Created by Matin on 2/1/23.
//

import Foundation

struct Widget {
    let type: WidgetType
    let data: Any
}

enum WidgetType {
    case textfield
    case checkbox
    case selector
    case screen
    case divider
    case title
    case textView
}
