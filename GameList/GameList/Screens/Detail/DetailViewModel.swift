//
//  DetailViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 21.05.2024.
//

import Foundation
import CoreData

// MARK: - Delegate
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
    func getWebsite(from url: String)
}

// MARK: - Protocol
protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }

    func load()
    func getBackgroundImage() -> String?
    func getName() -> String?
    func getMetaCritic() -> Int?
    func getReleaseDate() -> String?
    func getDescription() -> String?
    func goToMetacritic()
    func goToReddit()
    func likeGame()
    func dislikeGame()
    func isLiked() -> Bool
}

// MARK: - ViewModel
final class DetailViewModel {

    weak var delegate: DetailViewModelDelegate?
    private var name: String?
    private var metaCritic: Int?
    private var releaseDate: String?
    private var backgroundImage: String?
    private var platforms = [String]()
    private var gameID: Int
    private var description: String?
    private var retryCount = 0
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0
    private var metacriticURL: String?
    private var redditURL: String?

    init(gameID: Int) {
        self.gameID = gameID
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
                    self.metacriticURL = detail.metacriticURL
                    self.redditURL = detail.redditURL
                    for platform in detail.platforms! {
                        self.platforms.append(platform.platform?.name ?? "")
                    }
                    self.checkPlatforms()
                    self.backgroundImage = detail.backgroundImage
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

    func isLiked() -> Bool {
        /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedGames")
        request.predicate = NSPredicate(format: "name = %@", name!)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                return true
            }
        } catch {
            print("Error: \(error)")
        }
        return false
        self.delegate?.detailViewModelDidFetchData()*/
        return false
    }

    func dislikeGame() {
        /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LikedGames")
        request.predicate = NSPredicate(format: "name = %@", name!)
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                context.delete(result[0] as! NSManagedObject)
                try context.save()
                print("Deleted")
            }
        } catch {
            print("Error: \(error)")
        }*/
    }

    func likeGame() {
      /*  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "LikedGames", in: context) {
            let newLikedGame = NSManagedObject(entity: entity, insertInto: context)
            newLikedGame.setValue(name, forKey: "name")
            newLikedGame.setValue(metaCritic, forKey: "score")
            newLikedGame.setValue(releaseDate, forKey: "releaseDate")
            newLikedGame.setValue(backgroundImage.image?.pngData(), forKey: "image")
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Error: \(error)")
            }
        } else {
            print("Failed to create entity description")
        }*/
    }

    func goToMetacritic() {
        if let url = metacriticURL {
            delegate?.getWebsite(from: url)
        }
    }

    func goToReddit() {
        if let url = redditURL {
            delegate?.getWebsite(from: url)
        }
    }

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

    func getBackgroundImage() -> String? {
        backgroundImage
    }

    func load() {
        fetchGames()
    }
}
