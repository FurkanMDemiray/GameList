//
//  DetailViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import Foundation
import SDWebImage

protocol DetailViewModelDelegate: AnyObject {
    func detailViewModelDidFetchData()
    func showLoadingView()
    func hideLoadingView()
    func showViews()
    func reloadImage()
    func showXbox()
    func showPC()
    func showPS()
}

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }

    func load()
    func getBackgroundImage() -> UIImage?
    func getName() -> String?
    func getMetaCritic() -> Int?
    func getReleaseDate() -> String?
    func getDescription() -> String?
}

final class DetailViewModel {

    weak var delegate: DetailViewModelDelegate?
    var name: String?
    var metaCritic: Int?
    var releaseDate: String?
    var backgroundImage = UIImageView()
    var platforms = [String]()
    var gameID: Int
    var description: String?

    init(gameID: Int) {
        self.gameID = gameID
    }

    fileprivate func getBackgroundImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: url) {
            SDWebImageDownloader.shared.downloadImage(with: url) { image, _, _, _ in
                completion(image)
            }
        }
    }

    fileprivate func checkPlatforms() {
        for platform in platforms {
            if platform.contains("Xbox") {
                delegate?.showXbox()
            } else if platform == "PC" {
                delegate?.showPC()
            } else if platform.contains("PlayStation") {
                delegate?.showPS()
            }
        }
    }

    fileprivate func fetchGames() {
        delegate?.showLoadingView()
        NetworkManager.shared.fetch(from: Constants.detailUrl(gameID), as: DetailModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detail):
                DispatchQueue.main.async {
                    self.metaCritic = detail.metacritic
                    self.releaseDate = detail.released
                    self.name = detail.name
                    self.description = detail.description
                    for platform in detail.platforms! {
                        self.platforms.append(platform.platform?.name ?? "")
                    }
                    self.checkPlatforms()
                    self.getBackgroundImage(url: detail.backgroundImage ?? "") { image in
                        self.backgroundImage.image = image
                        self.delegate?.reloadImage()
                    }
                    self.delegate?.detailViewModelDidFetchData()
                    self.delegate?.hideLoadingView()
                    self.delegate?.showViews()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    func getDescription() -> String? {
        description
    }
    

    func getName() -> String? {
        name
    }

    func getMetaCritic() -> Int? {
        metaCritic
    }

    func getReleaseDate() -> String? {
        releaseDate
    }

    func getBackgroundImage() -> UIImage? {
        backgroundImage.image
    }

    func load() {
        fetchGames()
    }
}
