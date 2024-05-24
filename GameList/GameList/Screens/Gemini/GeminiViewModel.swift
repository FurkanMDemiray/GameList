//
//  GeminiViewModel.swift
//  GameList
//
//  Created by Melik Demiray on 24.05.2024.
//

import Foundation
import GoogleGenerativeAI

protocol GeminiViewModelDelegate: AnyObject {
    func printResponse()
}

protocol GeminiViewModelProtocol {
    var delegate: GeminiViewModelDelegate? { get set }

    func getResponse()
    func getCellWidhtHeight(_ size: CGFloat) -> CGFloat
}

final class GeminiViewModel {

    weak var delegate: GeminiViewModelDelegate?
    var names = [String]()
    var response = ""

    fileprivate func getNames() {
        for key in GameNameID.dict.keys {
            names.append(key)
        }
    }

    fileprivate func fetchResponse() async {
        getNames()
        let model = GenerativeModel(name: "gemini-pro", apiKey: Constants.geminiAPIKey)

        let prompt = "Suggest me a only one game according to the this features (action,rpg,chill,high graphics) I mentioned among the games in this \(names) game list."
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                self.response = text
                print(text)
                delegate?.printResponse()
            }
        } catch {
            print(error)
        }
    }

}

extension GeminiViewModel: GeminiViewModelProtocol {

    func getCellWidhtHeight(_ size: CGFloat) -> CGFloat {
        let padding: CGFloat = 10
        let collectionViewSize = size - padding * 4
        let cellWidth = collectionViewSize / 4
        return cellWidth
    }

    func getResponse() {
        Task {
            await fetchResponse()
        }
    }
}
