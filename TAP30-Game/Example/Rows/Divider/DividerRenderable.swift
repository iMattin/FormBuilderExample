//
//  DividerRenderable.swift
//  TAP30-Game
//
//  Created by Matin on 2/4/23.
//

import UIKit

class DivadierRow: RenderableFormRow {
    var identifier: String {
        "random id"
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(DividerCell.self, forCellWithReuseIdentifier: "dividerCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        return renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "dividerCell", for: indexPath)
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        3.0
    }
}
