//
//  TextFieldCell.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit
import Combine

class TextFieldCell: BaseCell<UITextField> {
    var viewModel: TextFieldViewModelProtcol?

    private lazy var textField: UITextField = embeddedView
    private var cancellabel = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with viewModel: TextFieldViewModelProtcol) {
        self.viewModel = viewModel
        cancellabel = .init()
        viewModel.textPublisher
            .sink { [unowned self] text in
            self.textField.text = text
        }.store(in: &cancellabel)

        viewModel.isEnabledPublisher.sink { [unowned self] isEnabled in
            self.textField.isEnabled = isEnabled
        }.store(in: &cancellabel)
    }

    @objc func onTextChange() {
        viewModel?.update(text: textField.text)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

protocol TextViewCellDelegate: AnyObject {
    func textViewCell(_ cell: TextViewCell, didChangedText: String?)
}

class TextViewCell: BaseCell<UITextView> {

    weak var delegate: TextViewCellDelegate?

    var viewModel: TextFieldViewModelProtcol?
    private var cancellabel = Set<AnyCancellable>()

    private lazy var textView: UITextView = embeddedView

    override init(frame: CGRect) {
        super.init(frame: frame)
        embeddedView.delegate = self
        embeddedView.layer.borderWidth = 1
        embeddedView.layer.borderColor = UIColor.systemGray5.cgColor
        embeddedView.layer.cornerRadius = 6
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with viewModel: TextFieldViewModelProtcol) {
        self.viewModel = viewModel
        cancellabel = .init()

        viewModel.textPublisher
            .sink { [unowned self] text in
            self.textView.text = text
        }.store(in: &cancellabel)

        viewModel.isEnabledPublisher.sink { [unowned self] isEnabled in
            self.textView.isEditable = isEnabled
        }.store(in: &cancellabel)
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel?.update(text: textView.text)
        delegate?.textViewCell(self, didChangedText: textView.text)
    }
}

