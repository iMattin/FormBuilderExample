//
//  SwitchFieSwitchRowld.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit

class SwitchRow: RenderableFormRow {

    let identifier: String
    let viewModel: SwitchViewModel

    init(identifier: String, viewModel: SwitchViewModel) {
        self.identifier = identifier
        self.viewModel = viewModel
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(SwitchCell.self, forCellWithReuseIdentifier: "switchCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "switchCell", for: indexPath) as! SwitchCell
        cell.config(with: viewModel)
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        40.0
    }
}
