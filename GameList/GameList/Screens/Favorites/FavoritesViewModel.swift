//
//  FavoritesVievModel.swift
//  GameList
//
//  Created by Melik Demiray on 22.05.2024.
//

import Foundation
import CoreData

protocol FavoritesViewModelDelegate: AnyObject {
    func reloadTableView()
    func showNoData()
}

protocol FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate? { get set }

    func getData()
    func getNumberOfItems() -> Int
    func getItem(at index: Int) -> FavoritesModel
    func deleteItem(at index: Int)
    func getGameID(name: String) -> Int
}

final class FavoritesViewModel {

    weak var delegate: FavoritesViewModelDelegate?
    private let context: NSManagedObjectContext
    var models: [FavoritesModel] = []

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    fileprivate func fetchData() {
        self.models.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames")
        DispatchQueue.main.async {
            do {
                let result = try self.context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let name = data.value(forKey: "name") as? String
                    let score = data.value(forKey: "score") as? Double
                    let releaseDate = data.value(forKey: "releaseDate") as? String
                    let image = data.value(forKey: "image") as? String
                    self.models.append(FavoritesModel(name: name, score: score, releaseDate: releaseDate, image: image))
                    self.delegate?.reloadTableView()
                    self.delegate?.showNoData()
                }
            } catch {
                print("Failed")
            }
        }
    }

}

extension FavoritesViewModel: FavoritesViewModelProtocol {

    func getGameID(name: String) -> Int {
        for (key, value) in GameNameID.dict {
            if key == name {
                return value
            }
        }
        return 0
    }

    func deleteItem(at index: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteGames")
        request.predicate = NSPredicate(format: "name = %@", models[index].name!)
        do {
            let result = try context.fetch(request)
            if let gameToDelete = result.first as? NSManagedObject {
                context.delete(gameToDelete)
                try context.save()
                delegate?.reloadTableView()
            }
        } catch {
            print("Error: \(error)")
        }
    }

    func getNumberOfItems() -> Int {
        models.count
    }

    func getItem(at index: Int) -> FavoritesModel {
        return models[index]
    }

    func getData() {
        fetchData()
        if models.isEmpty {
            delegate?.showNoData()
        }
    }
}
