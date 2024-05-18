//
//  ViewController.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var gameImage: UIImageView!
    var games: GameModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            DispatchQueue.main.async {
                for game in games.results! {
                    if let name = game.name {
                        print(name)
                    }
                }
                self.gameImage.downloaded(from: games.results![0].backgroundImage ?? "")
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

