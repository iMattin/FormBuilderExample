//
//  TitleRenderable.swift
//  TAP30-Game
//
//  Created by Matin on 2/7/23.
//

import UIKit

protocol TitleRowDataSource {
    var title: String { get }
}

class TitleRow: RenderableFormRow {
    let identifier: String
    let dataSource: TitleRowDataSource

    init(identifier: String, dataSource: TitleRowDataSource) {
        self.identifier = identifier
        self.dataSource = dataSource
    }

    func registerCell(in renderer: FormRendererViewController) {
        renderer.collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "titleCell")
    }

    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = renderer.collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! TitleCell
        cell.config(with: dataSource.title)
        return cell
    }

    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat {
        40.0
    }
}

extension String: TitleRowDataSource {
    var title: String { self }
}
