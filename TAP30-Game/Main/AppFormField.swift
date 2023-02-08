//
//  AppFormField.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

class AppFormField: FormField {

    let field: `Type`

    init(field: `Type`) {
        self.field = field
    }

    enum `Type` {
        case textField(TextFieldViewModel)
        case textView(TextFieldViewModel)
        case `switch`(SwitchViewModel)
        case selector(SelectorViewModel)
        case divider
        case screen(ScreenRowViewModel)
        case title(Widgets_TitleData)
        case customTitle(String)
    }

    var type: FormFieldType {
        switch field {
        case .textField(let textFieldViewModel):
            return .valuable(textFieldViewModel)
        case .textView(let textFieldViewModel):
            return .valuable(textFieldViewModel)
        case .`switch`(let switchViewModel):
            return .valuable(switchViewModel)
        case .selector(let viewModel):
            return .valuable(viewModel)
        case .divider:
            return .displayable
        case .screen(let viewModel):
            return .valuable(viewModel)
        case .title, .customTitle:
            return .displayable
        }
    }
}
