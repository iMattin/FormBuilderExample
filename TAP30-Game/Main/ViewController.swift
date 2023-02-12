//
//  ViewController.swift
//  TAP30-Game
//
//  Created by Matin on 3/20/22.
//

import UIKit

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
        let vc = StickyFormPageViewController(viewModel: vm, generator: DefaultFormPageRowGenerator())
        (presentedViewController as? UINavigationController)?.pushViewController(vc, animated: true)
    }
}
