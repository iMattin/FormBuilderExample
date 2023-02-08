//
//  SelectorRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/2/23.
//

import UIKit

class SelectorRow: RenderableFormRow {
    let identifier: String
    let viewModel: SelectorViewModelProtocol

    init(identifier: String, viewModel: SelectorViewModelProtocol) {
        self.identifier = identifier
        self.viewModel = viewModel
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(SelectorCell.self, forCellWithReuseIdentifier: "selectorCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "selectorCell", for: indexPath) as! SelectorCell
        cell.config(with: viewModel)
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        44.0
    }
}

extension SelectorRow: SelectableFormRow {
    func didSelectRow() {
        viewModel.select()
    }
}
