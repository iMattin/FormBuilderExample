//
//  FormRowGenerator.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

struct DefaultFormPageRowGenerator: FormPageViewControllerRowGenerator {
    func generateRow(_ vc: FormPageViewController, with field: FormField) -> any RenderableFormRow {

        guard let field = field as? AppFormField else { fatalError() }

        switch field.field {
        case .textField(let textFieldViewModel):
            return BaseFormRow(decoratee: TextFieldRow(identifier: textFieldViewModel.key, viewModel: textFieldViewModel), viewModel: textFieldViewModel)
        case .textView(let textFieldViewModel):
            return BaseFormRow(decoratee: TextViewRow(identifier: textFieldViewModel.key, viewModel: textFieldViewModel), viewModel: textFieldViewModel)
        case .switch(let switchViewModel):
            return SwitchRow(identifier: switchViewModel.key, viewModel: switchViewModel)
        case .selector(let viewModel):
            return BaseFormRow(decoratee: SelectorRow(identifier: viewModel.key, viewModel: viewModel), viewModel: viewModel)
        case .divider:
            return DivadierRow()
        case .screen(let viewModel):
            return BaseFormRow(decoratee: SelectorRow(identifier: viewModel.key, viewModel: viewModel), viewModel: viewModel)
        case .title(let widget):
            return TitleRow(identifier: widget.title, dataSource: widget)
        case .customTitle(let title):
            return TitleRow(identifier: title, dataSource: title)
        }
    }
}
