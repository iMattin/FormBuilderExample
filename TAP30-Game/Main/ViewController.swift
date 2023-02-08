//
//  ViewController.swift
//  TAP30-Game
//
//  Created by Matin on 3/20/22.
//

import UIKit


struct SubmitStrategy: StickyFormPageSubmitStrategy {
    func onSubmit(_ inputItems: [FormInputItemProtocol], _ completion: @escaping () -> Void) -> StickyFormPageStatus {
        let dics = inputItems.compactMap {
            $0 as? GettableRow
        }.map { $0.keyValuePair }

        let json = try! JSONEncoder().encode(dics)
        print(json.prettyPrintedJSONString!)

        return .none
    }
}

struct ValueChangeStrategy: StickyFormPageValueChangeStrategy {
    func onValueChange<Value>(_ item: FormInputItem<Value>, fields: [FormField], completion: @escaping ([FormField]) -> Void) -> StickyFormPageStatus where Value : Equatable {
        guard let textInput = item as? TextFieldViewModel, textInput.key == "field1" else { return .none }
        let screen = fields.compactMap { $0.type.inputItem }.compactMap { $0 as? SettableRow }.first(where: { $0.key == "screen1" })
        screen?.setValue(.nested(values: [
            "screen2": .nested(values: [
                "innter_field1": .string(value: textInput.value ?? "")
            ])
        ]))
        return .none
    }
}

struct ScreenSubmitStrategy: StickyFormPageSubmitStrategy {
    let submitClosure: ([KeyValuePairs]) -> Void

    func onSubmit(_ inputItems: [FormInputItemProtocol], _ completion: @escaping () -> Void) -> StickyFormPageStatus {
        let dics = inputItems.compactMap {
            $0 as? GettableRow
        }.map { $0.keyValuePair }
        submitClosure(dics)
        completion()
        return .none
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.launch()
    }

    func launch() {
        var mapper = DefaultWidgetToFormFieldMapper()
        mapper.selectorDelegate = self
        mapper.screenDelegate = self

        let dataProvider = OfflineDataProvider(mapper: mapper, widgets: WIDGETS, filledData: nil)

        let viewModel = StickyFormPageViewModel(dataProvider: dataProvider, submitStrategy: SubmitStrategy(), valueChangeStrategy: ValueChangeStrategy())
        let vc = StickyFormPageViewController(viewModel: viewModel, generator: DefaultFormPageRowGenerator())

        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: true)
    }
}

extension ViewController: SelectorViewModelDelegate {
    func selector(_ viewModel: SelectorViewModel, didRequestSelectFrom items: [Widgets_SelectorData.SelectItem]) {
        let alert = UIAlertController(title: "Select", message: "please select an item", preferredStyle: .actionSheet)
        for item in items {
            alert.addAction(.init(title: item.title, style: item.id == viewModel.value ? .destructive : .default, handler: { [weak viewModel] _ in
                viewModel?.setValue(item.id == viewModel?.value ? nil : item.id)
            }))
        }
        alert.addAction(.init(title: "cancel", style: .cancel))
        presentedViewController?.present(alert, animated: true)
    }
}

extension ViewController: ScreenRowViewModelDelegate {
    func screenRowViewModel(_ viewModel: ScreenRowViewModel, widgets: [Widget], preset data: KeyValuePairs?) {
        var vc: StickyFormPageViewController!
        let submitStrategy = ScreenSubmitStrategy { [weak self] result in
            viewModel.setValue(result.reduce([:], { partialResult, dic in
                partialResult.merging(dic) { c, _ in c }
            }))
            (self?.presentedViewController as? UINavigationController)?.popViewController(animated: true)
        }
        var mapper = DefaultWidgetToFormFieldMapper()
        mapper.selectorDelegate = self
        mapper.screenDelegate = self

        let dataProvider = OfflineDataProvider(mapper: mapper, widgets: widgets, filledData: data)
        let vm = StickyFormPageViewModel(dataProvider: dataProvider, submitStrategy: submitStrategy)
        vc = .init(viewModel: vm, generator: DefaultFormPageRowGenerator())
        (presentedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
    }
}
