//
//  Constants.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation


struct Constants {
    static let baseUrl = "https://api.rawg.io/api/games?key=6aad45ddf0f54bb8a81a5d3cbd5163ca"

    static let detailUrl = {
        (id: Int) -> String in
        return "https://api.rawg.io/api/games/\(id)?key=6aad45ddf0f54bb8a81a5d3cbd5163ca"
    }

    static let geminiAPIKey = "AIzaSyDudMp41Dtn6SvUnhoTgmGjWdQpB5hxYLQ"
}
