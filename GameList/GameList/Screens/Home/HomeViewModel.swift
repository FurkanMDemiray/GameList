//
//  HomeViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation
import SDWebImage

protocol HomeViewModelDelegate: AnyObject {
    func reloadGamesCollectionView()
    func reloadSliderCollectionView()
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfGames: Int { get }

    func load()
    func getGameModel() -> GameModel?
    func getResults() -> [Results]
    func getFirstThreeImages() -> [UIImage]
}

final class HomeViewModel {

    weak var delegate: HomeViewModelDelegate?
    var game: GameModel?
    var results = [Results]()
    var images = [UIImage]()

    fileprivate func getFirstThreeImages(urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images = Array<UIImage?>(repeating: nil, count: min(3, urls.count))
        let dispatchGroup = DispatchGroup()

        for i in 0..<min(3, urls.count) {
            if let url = URL(string: urls[i]) {
                dispatchGroup.enter()
                SDWebImageDownloader.shared.downloadImage(with: url) { image, _, _, _ in
                    if let image = image {
                        images[i] = image
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(images.compactMap { $0 })
        }
    }

    fileprivate func fetchGames() {
        NetworkManager.shared.fetch(from: Constants.baseUrl, as: GameModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let game):
                DispatchQueue.main.async {
                    self.game = game
                    if let results = game.results {
                        self.results = results
                        self.delegate?.reloadGamesCollectionView()
                        self.getFirstThreeImages(urls: results.map { $0.backgroundImage ?? "" }) { images in
                            self.images = images
                            self.delegate?.reloadSliderCollectionView()
                        }
                    }
                }
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {

    func getFirstThreeImages() -> [UIImage] {
        images
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
