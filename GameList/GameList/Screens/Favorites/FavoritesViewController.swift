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
    }   

    private func configureColectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
    }

}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        return cell
    }

}

extension FavoritesViewController: FavoritesViewModelDelegate {   

    func didFetchData() {
        
    }

}
