//
//  BaseViewModel.swift
//  TAP30-Game
//
//  Created by Matin on 1/31/23.
//

import Foundation
import Combine

class BaseFormItemViewModel<ValueType: Equatable>: FormInputItem<ValueType>, BaseViewModelProtocol, Identifiable, ErrorableRow {

    let key: String

    lazy var message$: AnyPublisher<RowMessage?, Never> = {
        $_rowMessage.eraseToAnyPublisher()
    }()

    lazy var moreInfo$: AnyPublisher<String?, Never> = {
        $_moreInfo.map { $0?.label }.eraseToAnyPublisher()
    }()

    lazy var showFooter$: AnyPublisher<Bool, Never> = {
        statusChanges.map { $0 != .disabled }
            .combineLatest(dirtyChanges, { isEnabled, isDirty in
                isEnabled && isDirty
            }).eraseToAnyPublisher()
    }()

    var hasFooter: Bool {
        enabled && isDirty && (_rowMessage != nil || _moreInfo != nil)
    }

    var rowMessage: RowMessage? {
        get {
            _rowMessage
        }
        set {
            if newValue == nil && _defaultMessage != nil {
                _rowMessage = _defaultMessage
            } else {
                _rowMessage = newValue
            }
        }
    }

    var moreInfo: RowMoreInfo? {
        get {
            _moreInfo
        }
        set {
            _moreInfo = newValue
        }
    }

    @Published private var _rowMessage: RowMessage?
    @Published private var _moreInfo: RowMoreInfo?

    private let _defaultMessage: RowMessage?

    init(key: String, value: ValueType? = nil, defaultMessage: RowMessage? = nil) {
        _defaultMessage = defaultMessage
        _rowMessage = defaultMessage
        self.key = key
        super.init(value: value)
    }

    func onMoreInfoClicked() {
    }

    func makeDirty() {
        isDirty = true
    }
}

extension BaseFormItemViewModel where ValueType == String {
    func addRequiredValidator() {
        add(validator: RequiredValidator<String>(message: "Required message", onExecution: { [weak self] isValid in
            self?.rowMessage = isValid ? nil : .error("this field is required")
        }))
    }
}
