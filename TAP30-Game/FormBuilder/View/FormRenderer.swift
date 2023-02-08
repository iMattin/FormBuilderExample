//
//  FormRenderer.swift
//  TAP30-Game
//
//  Created by Matin on 1/29/23.
//

import UIKit

class FormRendererViewController: UIViewController {

    var rows: [any RenderableFormRow] = [] {
        didSet { reload() }
    }

    // - MARK: UI
    private(set) var collectionView: UICollectionView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
    }

    private func reload() {
        registerCells()
        collectionView.reloadData()
    }

    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0)
        ])

        collectionView.contentInset = .zero
        collectionView.backgroundColor = .white
    }

    private func registerCells() {
        rows.forEach { $0.registerCell(in: self) }
    }
}

extension FormRendererViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let row = rows[safe: indexPath.item] else { return .zero }
        let height = row.calculateCellHeight(self)
        return .init(width: collectionView.frame.width, height: height)
    }
}

extension FormRendererViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let row = rows[safe: indexPath.row] else { return UICollectionViewCell() }
        let cell = row.renderCell(with: self, at: indexPath)
        config(row: row, at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (rows[safe: indexPath.row] as? SelectableFormRow)?.didSelectRow()
    }

    private func config(row: any RenderableFormRow, at indexPath: IndexPath) {
        guard let resizableRow = row as? ResizableFormRow else { return }
        resizableRow.register { [weak self] forceReload, animated in
            self?.handleRowHeightChanges(at: indexPath, forceReload: forceReload, animated: animated)
        }
    }

    private func handleRowHeightChanges(at indexPath: IndexPath, forceReload: Bool, animated: Bool) {
        if forceReload {
            collectionView.performBatchUpdates {
                collectionView.reloadItems(at: [indexPath])
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
}
