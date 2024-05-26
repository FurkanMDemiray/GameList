//
//  HomeViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation

// MARK: - Delegate
protocol HomeViewModelDelegate: AnyObject {
    func reloadGamesTableView()
    func reloadSliderCollectionView()
    func hideSlider()
    func showSlider()
    func showPageControl()
    func showLoading()
    func hideLoading()
    func showNoData()
}

// MARK: - Protocol
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfGames: Int { get }

    func load()
    func loadMoreGames()
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
    var originalResults = [Results]()
    var imagesURL = [String]()
    var nextPageURL: String?

// MARK: - Fetch Games
    fileprivate func fetchGames(from url: String? = Constants.baseUrl) {
        guard let url = url else { return }
        self.delegate?.showLoading()
        NetworkManager.shared.fetch(from: url, as: GameModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                DispatchQueue.main.async {
                    self.game = game
                    self.nextPageURL = game.next // Update nextPageURL
                    if let newResults = game.results {
                        // Append new results only if they are not already present
                        let existingIds = Set(self.results.map { $0.id })
                        let uniqueNewResults = newResults.filter { !existingIds.contains($0.id) }
                        self.results.append(contentsOf: uniqueNewResults)
                        self.originalResults.append(contentsOf: uniqueNewResults)

                        self.imagesURL.append(contentsOf: uniqueNewResults.compactMap { $0.backgroundImage })
                        var imageUrlsDict = [String: [String]]()

                        for result in self.results {
                            if let name = result.name, let imageUrl = result.backgroundImage {
                                if imageUrlsDict[name] != nil {
                                    imageUrlsDict[name]?.append(imageUrl)
                                } else {
                                    imageUrlsDict[name] = [imageUrl]
                                }
                            }
                        }

                        GameNameID.imageUrls = imageUrlsDict.mapValues { $0.first ?? "" }
                        GameNameID.gameNameIdDict = Dictionary(uniqueKeysWithValues: self.results.compactMap { ($0.name ?? "", $0.id ?? 0) })

                        self.delegate?.reloadGamesTableView()
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

// MARK: - Remove Duplicates
    fileprivate func removeDuplicates(_ results: inout [Results]) {
        var uniqueResults = [Results]()
        var seenIds = Set<Int>()

        for result in results {
            guard let id = result.id else { continue }
            if !seenIds.contains(id) {
                uniqueResults.append(result)
                seenIds.insert(id)
            }
        }
        results = uniqueResults
    }

}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {

    func getGameId(at index: Int) -> Int {
        results[index].id ?? 0
    }

    func searchGames(with text: String) {
        if text.count >= 3 {
            removeDuplicates(&originalResults)
            removeDuplicates(&results)
            let filteredResults = originalResults.filter {
                $0.name?.lowercased().contains(text.lowercased()) ?? false
            }
            print("Filtered Results: ", filteredResults)
            delegate?.hideSlider()
            results = filteredResults
        } else {
            delegate?.showSlider()
            results = originalResults
        }
        delegate?.reloadGamesTableView()
    }

    func getFirstThreeImages() -> [String] {
        Array(imagesURL.prefix(3))
    }

    func load() {
        fetchGames()
    }

    func loadMoreGames() {
        fetchGames(from: nextPageURL)
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
