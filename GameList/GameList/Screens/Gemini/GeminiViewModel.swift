//
//  GeminiViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 24.05.2024.
//

import Foundation
import GoogleGenerativeAI

protocol GeminiViewModelDelegate: AnyObject {
    func didReceiveResponse()
}

protocol GeminiViewModelProtocol {
    var delegate: GeminiViewModelDelegate? { get set }

    func getResponse(features: [String])
    func getCellWidhtHeight(_ size: CGFloat) -> CGFloat
    func getGenres() -> [String]
    func addFeature(_ feature: String)
    func removeFeature(_ feature: String)
    func getFeatures() -> [String]
    func clearFeatures()
    func getImageUrl() -> String
    func getCollectionViewHeight(width: CGFloat, itemCount: Int) -> CGFloat
}

final class GeminiViewModel {

    weak var delegate: GeminiViewModelDelegate?
    var names = [String]()
    var response = ""
    var features = [String]()
    var imageIndex = 0
    var responseGame = ""

    fileprivate func getNames() {
        for key in GameNameID.dict.keys {
            names.append(key)
        }
    }

    fileprivate func fetchResponse(features: [String]) async {
        getNames()
        let model = GenerativeModel(name: "gemini-pro", apiKey: Constants.geminiAPIKey)
        let prompt = "Suggest me a only one game according to the this features \(features) I mentioned among the games in this \(names) game list. Just give me the name of the game."
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                self.response = text
                self.responseGame = text
                self.delegate?.didReceiveResponse()
            }
        } catch {
            print(error)
        }
    }

}

extension GeminiViewModel: GeminiViewModelProtocol {

    func getCollectionViewHeight(width: CGFloat, itemCount: Int) -> CGFloat {
        let padding: CGFloat = 10
        let cellHeight = getCellWidhtHeight(width)
        let itemsPerRow: CGFloat = 4
        let totalRows = ceil(CGFloat(itemCount) / itemsPerRow)
        let collectionViewHeight = totalRows * cellHeight + (totalRows + 1) * padding
        return collectionViewHeight
    }

    func getImageUrl() -> String {
        if GameNameID.imageUrls.keys.contains(responseGame) {
            return GameNameID.imageUrls[responseGame] ?? ""
        }
        return ""
    }

    func removeFeature(_ feature: String) {
        if let index = features.firstIndex(of: feature) {
            features.remove(at: index)
        }
    }

    func clearFeatures() {
        features.removeAll()
    }

    func getFeatures() -> [String] {
        features
    }

    func addFeature(_ feature: String) {
        features.append(feature)
        print(features)
    }

    func getGenres() -> [String] {
        let genres = ["Action", "RPG", "Chill", "TPS", "Multiplayer", "Platformer", "Story", "Co-Op", "Puzzle", "Shooter", "Looter", "2D"]
        return genres
    }

    func getCellWidhtHeight(_ size: CGFloat) -> CGFloat {
        let padding: CGFloat = 10
        let collectionViewSize = size - padding * 5
        let cellWidth = collectionViewSize / 4
        return cellWidth
    }

    func getResponse(features: [String]) {
        Task {
            await fetchResponse(features: features)
        }
    }
}