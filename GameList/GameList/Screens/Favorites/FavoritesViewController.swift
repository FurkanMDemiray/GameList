//
//  FavoritesViewController.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var favoritesViewModel: FavoritesViewModelProtocol! {
        didSet {
            favoritesViewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureColectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        favoritesViewModel.getData()
    }

    private func configureColectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
    }

}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesViewModel.getNumberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        let item = favoritesViewModel.getItem(at: indexPath.row)
        cell.configureCell(model: item)
        return cell*/
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 116)
    }

    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                self?.favoritesViewModel.deleteItem(at: indexPath.row)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
