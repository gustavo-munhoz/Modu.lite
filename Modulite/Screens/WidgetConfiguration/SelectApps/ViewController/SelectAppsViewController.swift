//
//  SelectAppsViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 05/09/24.
//

import UIKit

class SelectAppsViewController: UIViewController {
    
    // MARK: - Properties
    private let selectAppsView = SelectAppsView()
    private let viewModel = SelectAppsViewModel()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = selectAppsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        selectAppsView.setCollectionViewDelegate(to: self)
        selectAppsView.setCollectionViewDataSource(to: self)
    }
}

// MARK: - UICollectionViewDelegate
extension SelectAppsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let oldData = viewModel.apps
        let idx = indexPath.row
        
        // Atualizar o estado no modelo primeiro
        if viewModel.isAppSelected(at: idx) {
            viewModel.deselectApp(at: idx)
        } else {
            viewModel.selectApp(at: idx)
        }
        
        // Garantir que os dados do modelo estão atualizados antes de calcular as diferenças
        let newData = viewModel.apps
        let changes = calculateDifferences(old: oldData, new: newData)
        
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: changes.deletes)
            collectionView.insertItems(at: changes.inserts)
            changes.moves.forEach { move in
                collectionView.moveItem(at: move.from, to: move.to)
            }
//            collectionView.reloadItems(at: changes.reloads)
        }, completion: { _ in
            collectionView.reloadData()
        })

    }
}

// MARK: - UICollectionViewDataSource
extension SelectAppsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.apps.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppCollectionViewCell.reuseId,
            for: indexPath
        ) as? AppCollectionViewCell else {
            fatalError("Unable to dequeue AppCollectionViewCell")
        }
        let app = viewModel.apps[indexPath.row]
        cell.setup(with: viewModel.apps[indexPath.row])
        
        print("\(app.data.name): \(app.isSelected)")
        
        return cell
    }
}

struct CollectionChanges {
    var inserts: [IndexPath]
    var deletes: [IndexPath]
    var moves: [(from: IndexPath, to: IndexPath)]
    var reloads: [IndexPath]
}

func calculateDifferences(old: [SelectableAppInfo], new: [SelectableAppInfo]) -> CollectionChanges {
    var inserts: [IndexPath] = []
    var deletes: [IndexPath] = []
    var moves: [(from: IndexPath, to: IndexPath)] = []
    var reloads: [IndexPath] = []  // Adicionar uma lista para recarregamentos
    
    for (oldIndex, oldItem) in old.enumerated() {
        if let newIndex = new.firstIndex(where: { $0.data.name == oldItem.data.name }) {
            if oldIndex != newIndex {
                moves.append((from: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0)))
            } else if oldItem.isSelected != new[newIndex].isSelected {
                // Se a posição não mudou mas o estado de seleção mudou, marcar para recarregar
                reloads.append(IndexPath(row: oldIndex, section: 0))
            }
        } else {
            deletes.append(IndexPath(row: oldIndex, section: 0))
        }
    }

    for (newIndex, newItem) in new.enumerated() {
        if old.firstIndex(where: { $0.data.name == newItem.data.name }) == nil {
            inserts.append(IndexPath(row: newIndex, section: 0))
        }
    }
    
    return CollectionChanges(inserts: inserts, deletes: deletes, moves: moves, reloads: reloads)
}

private func getImageForState(selected: Bool) -> UIImage {
    (selected
     ? UIImage(systemName: "checkmark.circle.fill")!
     : UIImage(systemName: "circle")!
    ).withTintColor(.carrotOrange, renderingMode: .alwaysOriginal)
}
