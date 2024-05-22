//
//  HomeViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadGamesCollectionView()
    func reloadSliderCollectionView()
    func hideSlider()
    func showSlider()
    func showPageControl()
    func showLoading()
    func hideLoading()
    func showNoData()
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfGames: Int { get }

    func load()
    func getGameModel() -> GameModel?
    func getResults() -> [Results]
    func getFirstThreeImages() -> [String]
    func searchGames(with text: String)
    func getGameId(at index: Int) -> Int
}

final class HomeViewModel {

    weak var delegate: HomeViewModelDelegate?
    var game: GameModel?
    var results = [Results]()
    var imagesURL = [String]()

    fileprivate func fetchGames() {
        self.delegate?.showLoading()
        NetworkManager.shared.fetch(from: Constants.baseUrl, as: GameModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                DispatchQueue.main.async {
                    self.game = game
                    if let results = game.results {
                        self.results = results
                        self.imagesURL = results.compactMap { $0.backgroundImage }
                        self.delegate?.reloadGamesCollectionView()
                        self.delegate?.reloadSliderCollectionView()
                        self.delegate?.showPageControl()
                        self.delegate?.hideLoading()
                    }
                }
            case .failure(let error):
                print("Error", error)
                self.delegate?.showNoData()
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getGameId(at index: Int) -> Int {
        results[index].id ?? 0
    }

    func searchGames(with text: String) {
        if text.count >= 3 {
            let filteredResults = game?.results?.filter {
                $0.name?.lowercased().contains(text.lowercased()) ?? false
            }
            delegate?.hideSlider()
            results = filteredResults ?? []
        }
        else {
            delegate?.showSlider()
            results = game?.results ?? []
        }
        delegate?.reloadGamesCollectionView()
    }

    func getFirstThreeImages() -> [String] {
        Array(imagesURL.prefix(3))
    }

    func load() {
        fetchGames()
    }

    func getGameModel() -> GameModel? {
        game
    }

    func getResults() -> [Results] {
        results
    }

    var numberOfGames: Int {
        results.count
    }

}
