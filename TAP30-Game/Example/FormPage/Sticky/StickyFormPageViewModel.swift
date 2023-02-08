//
//  StickyFormPageViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import Foundation
import Combine

enum StickyFormPageStatus {
    case loading
    case none
}

protocol StickyFormPageSubmitStrategy {
    func onSubmit(_ inputItems: [FormInputItemProtocol], _ completion: @escaping () -> Void) -> StickyFormPageStatus
}

protocol StickyFormPageValueChangeStrategy {
    func onValueChange<Value: Equatable>(_ item: FormInputItem<Value>, fields: [FormField], completion:  @escaping (_ fields: [FormField]) -> Void)  -> StickyFormPageStatus
}

protocol StickyFormPageWidgetProvider {
    func provide(_ onLoad: @escaping (_ fields: [FormField]) -> Void) -> StickyFormPageStatus
}

class StickyFormPageViewModel: FormPageViewModel, StickyFormPageViewModelProtocol {

    lazy var statusPublisher: AnyPublisher<StickyFormPageStatus, Never> = $status.eraseToAnyPublisher()

    private let dataProvider: StickyFormPageWidgetProvider
    private let submitStrategy: StickyFormPageSubmitStrategy
    private let valueChangeStrategy: StickyFormPageValueChangeStrategy?

    @Published private var status: StickyFormPageStatus = .none

    init(dataProvider: StickyFormPageWidgetProvider,
         submitStrategy: StickyFormPageSubmitStrategy,
         valueChangeStrategy: StickyFormPageValueChangeStrategy? = nil) {
        self.dataProvider = dataProvider
        self.submitStrategy = submitStrategy
        self.valueChangeStrategy = valueChangeStrategy
        super.init()
    }

    lazy var stickyTitlePublisher: AnyPublisher<String, Never> = {
        form.statusChanges.map {
            switch $0 {
            case .invalid: return "Submit (invalid)"
            case .valid: return "Submit (OK)"
            case .disabled: return "Submit (disabled)"
            default: return "--"
            }
        }.eraseToAnyPublisher()
    }()

    func submit() {
        validateForm()
        guard form.valid else { return }

        status = submitStrategy.onSubmit(form.allInputItems) { [weak self] in
            guard let self else { return }
            self.status = .none
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func valueHasBeenChanged<Value: Equatable>(_ form: Form, item: FormInputItem<Value>, oldValue: Value?, newValue: Value?) {
        guard let valueChangeStrategy else { return }

        status = valueChangeStrategy.onValueChange(item, fields: form.fields) { [weak self] fields in
            guard let self else { return }
            self.status = .none
            self.set(fields: fields)
        }
    }

    private func loadData() {
        status = dataProvider.provide { [weak self] fields in
            guard let self else { return }

            self.status = .none
            self.set(fields: fields)
        }
    }
}
