//
//  GeminiViewController.swift
//  GameList
//
//  Created by Melik Demiray on 23.05.2024.
//

import UIKit
import GoogleGenerativeAI

class GeminiViewController: UIViewController {

    static var gameNames: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient()
        Task {
            await getResponseFromAI()
        }
    }

    private func getResponseFromAI() async {

        let model = GenerativeModel(name: "gemini-pro", apiKey: Constants.geminiAPIKey)

        let prompt = "Suggest me a only one game according to the this features (action,rpg,chill,high graphics) I mentioned among the games in this \(GeminiViewController.gameNames!) game list."
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                print(text)
            }
        } catch {
            print(error)
        }
    }

}
