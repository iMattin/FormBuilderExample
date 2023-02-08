//
//  WidgetToFormFieldMapper.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

protocol WidgetToFormFieldMapper {
    func map(widget: Widget) -> FormField
}

extension WidgetToFormFieldMapper {
    func map(widgets: [Widget]) -> [FormField] {
        widgets.map { map(widget: $0) }
    }
}

struct DefaultWidgetToFormFieldMapper: WidgetToFormFieldMapper {
    weak var selectorDelegate: SelectorViewModelDelegate?
    weak var screenDelegate: ScreenRowViewModelDelegate?

    func map(widget: Widget) -> FormField {
        switch widget.type {
        case .textfield:
            let data = widget.data as! Widgets_TextFieldData
            let viewModel = TextFieldViewModel(widget: data)
            return (AppFormField(field: .textField(viewModel)))
        case .checkbox:
            let data = widget.data as! Widgets_CheckboxData
            let viewModel = SwitchViewModel(widget: data)
            return (AppFormField(field: .switch(viewModel)))
        case .selector:
            let data = widget.data as! Widgets_SelectorData
            let viewModel = SelectorViewModel(widget: data)
            viewModel.delegate = selectorDelegate
            return (AppFormField(field: .selector(viewModel)))
        case .screen:
            let data = widget.data as! Widgets_ScreenData
            let viewModel = ScreenRowViewModel(widget: data)
            viewModel.delegate = screenDelegate
            return (AppFormField(field: .screen(viewModel)))
        case .title:
            let data = widget.data as! Widgets_TitleData
            return (AppFormField(field: .title(data)))
        case .divider:
            return (AppFormField(field: .divider))
        case .textView:
            let data = widget.data as! Widgets_TextFieldData
            let viewModel = TextFieldViewModel(widget: data)
            return (AppFormField(field: .textView(viewModel)))
        }
    }
}
