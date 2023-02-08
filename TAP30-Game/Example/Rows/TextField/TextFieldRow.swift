//
//  TextFieldRow.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit

class TextFieldRow: RenderableFormRow {

    let identifier: String
    let viewModel: TextFieldViewModelProtcol

    init(identifier: String, viewModel: TextFieldViewModelProtcol) {
        self.identifier = identifier
        self.viewModel = viewModel
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: "textFieldCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
        cell.config(with: viewModel)
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        60.0
    }
}


class TextViewRow: RenderableFormRow {

    let identifier: String
    let viewModel: TextFieldViewModelProtcol
    var heightChanges: OnRowHeightChange?

    init(identifier: String, viewModel: TextFieldViewModelProtcol) {
        self.identifier = identifier
        self.viewModel = viewModel
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(TextViewCell.self, forCellWithReuseIdentifier: "textViewCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "textViewCell", for: indexPath) as! TextViewCell
        cell.config(with: viewModel)
        cell.delegate = self
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
//        let text = viewModel.text ?? ""
//        let lines = text.split(separator: "\n")
        return 120.0 //+ CGFloat(lines.count * 20)
    }
}

extension TextViewRow: ResizableFormRow, TextViewCellDelegate {
    func register(onRowHeightChange: @escaping OnRowHeightChange) {
        heightChanges = onRowHeightChange
    }

    func textViewCell(_ cell: TextViewCell, didChangedText: String?) {
        heightChanges?(false, true)
    }
}
