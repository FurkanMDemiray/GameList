//
//  HomeViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadCollectionView()
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var nubmerOfItems: Int { get }

    func load()
    func getGameModel() -> GameModel?
    func getResults() -> [Results]
    func fetchGames()
}

final class HomeViewModel {

    weak var delegate: HomeViewModelDelegate?
    var game: GameModel?
    var results = [Results]()

    internal func fetchGames() {
        NetworkManager.shared.fetch(from: Constants.baseUrl, as: GameModel.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let game):
                DispatchQueue.main.async {
                    self.game = game
                    if let results = game.results {
                        self.results = results
                    }
                    self.delegate?.reloadCollectionView()
                }
            case .failure(let error):
                print("Error ", error)
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func load() {
        fetchGames()
    }

    func getGameModel() -> GameModel? {
        game
    }

    func getResults() -> [Results] {
        results
    }

    var nubmerOfItems: Int {
        results.count
    }
}
