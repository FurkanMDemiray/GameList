//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameImage: UIImageView!

    var games: GameModel?
    var results: [Results]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        setGradientBackground()
        configureGameImage()
        Task {
            await fetchGames()
        }
    }

    private func configureGameImage() {
        gameImage.layer.cornerRadius = 20
        gameImage.clipsToBounds = true
    }

    private func fetchGames() async {
        do {
            let games = try await NetworkManager.shared.fetch(from: NetworkManager.shared.url, as: GameModel.self)
            self.games = games
            self.results = games.results
            DispatchQueue.main.async {
                for game in games.results! {
                    if let name = game.name {
                        print(name)
                    }
                }
                self.gameImage.downloaded(from: games.results![0].backgroundImage ?? "")
                self.collectionView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    func setGradientBackground() {
        let colorTop = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.7, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games?.results?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.configureCell(with: games!.results![indexPath.row])
        return cell
    }

}

