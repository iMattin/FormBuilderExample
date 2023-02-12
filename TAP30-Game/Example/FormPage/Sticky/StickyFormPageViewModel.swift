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

enum StickyFormResult {
    case reload(_ fields: [FormField])
    case none
}

typealias SubmitCompletion = (_ result: StickyFormResult) -> Void

protocol StickyFormPageSubmitStrategy {
    func onSubmit(_ fields: [FormField], completion: @escaping SubmitCompletion) -> StickyFormPageStatus
}

protocol StickyFormPageValueChangeStrategy {
    func onValueChange<Value: Equatable>(_ item: FormInputItem<Value>, _ fields: [FormField], completion: @escaping SubmitCompletion) -> StickyFormPageStatus
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
        guard form.status != .invalid else { return }

        status = submitStrategy.onSubmit(form.fields, completion: { [weak self] result in
            self?.handle(result: result)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func valueHasBeenChanged<Value: Equatable>(_ form: Form, item: FormInputItem<Value>, oldValue: Value?, newValue: Value?) {
        guard let valueChangeStrategy else { return }

        status = valueChangeStrategy.onValueChange(item, form.fields, completion: { [weak self] result in
            self?.handle(result: result)
        })
    }

    private func loadData() {
        status = dataProvider.provide { [weak self] fields in
            self?.set(fields: fields)
        }
    }

    private func handle(result: StickyFormResult) {
        self.status = .none
        switch result {
        case .reload(let fields):
            self.set(fields: fields)
        case .none: break
        }
    }
}
