//
//  WidgetData.swift
//  TAP30-Game
//
//  Created by Matin on 2/1/23.
//

import Foundation

protocol Message {
}

struct Widgets_TextFieldData: Message {
    let key: String
    let placeholder: String
    let defaultValue: String
    var isEnabled = true
}

struct Widgets_CheckboxData: Message {
    let key: String
    let defaultValue: Bool
}

struct Widgets_SelectorData: Message {
    let key: String
    let placeholder: String
    let items: [SelectItem]
    let defaultValue: String

    struct SelectItem {
        let id: String
        let title: String
    }
}

struct Widgets_ScreenData: Message {
    let key: String
    let widgets: [Widget]
}

struct Widgets_TitleData: Message {
    let title: String
}

struct Widgets_DividerData: Message {
}

extension Widgets_TitleData: TitleRowDataSource {
}
