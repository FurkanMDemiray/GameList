//
//  GameService.swift
//  GameList
//
//  Created by Melik Demiray on 17.05.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingFailed
    case invalidResponse
}

class NetworkManager {

    static let shared = NetworkManager()
    private init() { }

    let url = "https://api.rawg.io/api/games?key=6aad45ddf0f54bb8a81a5d3cbd5163ca&dates=2019-09-01,2019-09-30&platforms=18,1,7"

    func fetch<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
