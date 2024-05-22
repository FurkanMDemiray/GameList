//
//  FavoritesVievModel.swift
//  GameList
//
//  Created by Melik Demiray on 22.05.2024.
//

import Foundation
import CoreData

protocol FavoritesViewModelDelegate: AnyObject {
    func didFetchData()
}

protocol FavoritesViewModelProtocol {
    var delegate: FavoritesViewModelDelegate? { get set }

    func getData()
}

final class FavoritesViewModel {

    weak var delegate: FavoritesViewModelDelegate?

    private func fetchData() {
        /*let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "metacritic") as! Int)
                print(data.value(forKey: "releaseDate") as! String)
                print(data.value(forKey: "backgroundImage") as! String)
            }
        } catch {
            print("Failed")
        }*/
    }
}

extension FavoritesViewModel: FavoritesViewModelProtocol {

    func getData() {
        
    }
}
