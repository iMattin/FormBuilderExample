//
//  Mock.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

let WIDGETS: [Widget] = [
    .init(type: .title, data: Widgets_TitleData(title: "Form")),
    .init(type: .textfield, data: Widgets_TextFieldData(key: "field1", placeholder: "name", defaultValue: "")),
    .init(type: .checkbox, data: Widgets_CheckboxData(key: "switch1", defaultValue: true)),
    .init(type: .textfield, data: Widgets_TextFieldData(key: "field2", placeholder: "name", defaultValue: "")),
    .init(type: .textfield, data: Widgets_TextFieldData(key: "field6", placeholder: "name", defaultValue: "")),
    .init(type: .selector, data: Widgets_SelectorData(key: "selector1", placeholder: "", items: [
        .init(id: "1", title: "item 1"),
        .init(id: "2", title: "item 2"),
        .init(id: "3", title: "item 3"),
        .init(id: "4", title: "item 4"),
        .init(id: "5", title: "item 5"),
        .init(id: "1", title: "item 1"),
        .init(id: "2", title: "item 2"),
        .init(id: "3", title: "item 3"),
        .init(id: "4", title: "item 4"),
        .init(id: "5", title: "item 5"),
        .init(id: "1", title: "item 1"),
        .init(id: "2", title: "item 2"),
        .init(id: "3", title: "item 3"),
        .init(id: "4", title: "item 4"),
        .init(id: "5", title: "item 5"),
    ], defaultValue: "2")),
    .init(type: .textfield, data: Widgets_TextFieldData(key: "field3", placeholder: "name", defaultValue: "")),
    .init(type: .textView, data: Widgets_TextFieldData(key: "field4", placeholder: "name", defaultValue: "")),
    .init(type: .divider, data: Widgets_DividerData()),
    .init(type: .screen, data: Widgets_ScreenData(key: "screen1", widgets: [
        .init(type: .title, data: Widgets_TitleData(title: "Inner Page")),
        .init(type: .selector, data: Widgets_SelectorData(key: "selector1", placeholder: "", items: [
            .init(id: "7", title: "item 7"),
            .init(id: "8", title: "item 8"),
        ], defaultValue: "")),
        .init(type: .checkbox, data: Widgets_CheckboxData(key: "innter_switch1", defaultValue: true)),
        .init(type: .screen, data: Widgets_ScreenData(key: "screen2", widgets: [
            .init(type: .title, data: Widgets_TitleData(title: "Inner Inner Page")),
            .init(type: .textfield, data: Widgets_TextFieldData(key: "innter_field1", placeholder: "name", defaultValue: "")),
        ]))
    ])),
    .init(type: .divider, data: Widgets_DividerData()),
    .init(type: .textfield, data: Widgets_TextFieldData(key: "field5", placeholder: "name", defaultValue: "")),
]
