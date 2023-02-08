//
//  RenderableFormRow.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import UIKit

protocol RenderableFormRow: AnyObject, Hashable {
    var identifier: String { get }

    func registerCell(in renderer: FormRendererViewController)
    func renderCell(with renderer: FormRendererViewController, at indexPath: IndexPath) -> UICollectionViewCell
    func calculateCellHeight(_ renderer: FormRendererViewController) -> CGFloat
}

extension RenderableFormRow {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
