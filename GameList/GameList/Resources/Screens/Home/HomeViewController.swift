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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchGames()
        }
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

}

