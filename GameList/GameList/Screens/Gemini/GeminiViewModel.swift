//
//  GeminiViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 24.05.2024.
//

import Foundation
import GoogleGenerativeAI

// MARK: - Delegate
protocol GeminiViewModelDelegate: AnyObject {
    func didReceiveResponse()
    func showIndicator()
    func hideIndicator()
}

// MARK: - Protocol
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
    func getGameName() -> String
}

final class GeminiViewModel {

    weak var delegate: GeminiViewModelDelegate?
    var names = [String]()
    var response = ""
    var features = [String]()
    var imageIndex = 0
    var responseGame = ""

    fileprivate func getNames() {
        for key in GameNameID.gameNameIdDict.keys {
            names.append(key)
        }
    }

// MARK: - Fetch Response
    fileprivate func fetchResponse(features: [String]) async {
        delegate?.showIndicator()
        getNames()
        let model = GenerativeModel(name: "gemini-pro", apiKey: Constants.geminiAPIKey)
        let prompt = "Suggest me a only one game according to the this features \(features) I mentioned among the games in this \(names) game list. Just give me the name of the game."
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                self.responseGame = text
                print(text)
                delegate?.didReceiveResponse()
            }
        } catch {
            print(error)
            delegate?.hideIndicator()
        }
        delegate?.hideIndicator()
    }

}

// MARK: - GeminiViewModelProtocol
extension GeminiViewModel: GeminiViewModelProtocol {

    func getGameName() -> String {
        responseGame
    }

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
        let features = ["Action", "RPG", "FPS", "TPS", "Multiplayer", "Platformer", "Story", "Co-Op", "Puzzle", "Shooter", "Looter", "MOBA"]
        return features
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
