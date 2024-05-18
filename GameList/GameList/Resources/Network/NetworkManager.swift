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
