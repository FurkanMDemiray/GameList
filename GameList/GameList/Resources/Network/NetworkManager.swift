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

    func fetch<T> (from urlString: String, as type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFailed))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
}
