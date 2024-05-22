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
    func showNoData()
    func hideNodata()
    func showError()
    func hideError()
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
    private var name: String?
    private var metaCritic: Int?
    private var releaseDate: String?
    private var backgroundImage = UIImageView()
    private var platforms = [String]()
    private var gameID: Int
    private var description: String?
    private var retryCount = 0
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0

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

// MARK: - Fetch Data
    fileprivate func fetchGames() {
        delegate?.showNoData()
        NetworkManager.shared.fetch(from: Constants.detailUrl(gameID), as: DetailModel.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let detail):
                DispatchQueue.main.async {
                    self.retryCount = 0
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
                    self.delegate?.hideNodata()
                    self.delegate?.showViews()
                    self.delegate?.hideError()
                }
            case .failure(let error):
                print(error)
                self.delegate?.showError()
                self.retryFetchGames()
            }
        }
    }

    fileprivate func retryFetchGames() {
        if retryCount < maxRetries {
            retryCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                self.fetchGames()
            }
        } else {
            DispatchQueue.main.async {
                self.delegate?.showNoData()
            }
        }
    }
}

// MARK: - DetailViewModelProtocol
extension DetailViewModel: DetailViewModelProtocol {
    func getDescription() -> String? {
        for words in description!.components(separatedBy: " ") {
            if words.contains("<p>") || words.contains("</p>") || words.contains("<br>") || words.contains("<br />") {
                description = description?.replacingOccurrences(of: "<p>", with: "")
                description = description?.replacingOccurrences(of: "</p>", with: "")
                description = description?.replacingOccurrences(of: "<br>", with: "")
                description = description?.replacingOccurrences(of: "<br />", with: "")
                if words.contains("Español") {
                    // delete the rest of the string
                    description = description?.components(separatedBy: "Español")[0]
                }
            }
        }
        return description
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
