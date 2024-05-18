//
//  Games.swift
//  GameList
//
//  Created by Melik Demiray on 18.05.2024.
//

import Foundation

import Foundation

// MARK: - GameModel
struct GameModel: Decodable {
    let count: Int?
    let next: String?
    let previous: JSONNull?
    let results: [Results]?
    let userPlatforms: Bool?

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case userPlatforms = "user_platforms"
    }
}

// MARK: - Result
struct Results: Decodable {
    let slug, name: String?
    let playtime: Int?
    let platforms: [Platform]?
    let stores: [Store]?
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount, reviewsTextCount, added: Int?
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let suggestionsCount: Int?
    let updated: String?
    let id: Int?
    let score, clip: JSONNull?
    let tags: [Tag]?
    let esrbRating: EsrbRating?
    let userGame: JSONNull?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: Color?
    let shortScreenshots: [ShortScreenshot]?
    let parentPlatforms: [Platform]?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case slug, name, playtime, platforms, stores, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic
        case suggestionsCount = "suggestions_count"
        case updated, id, score, clip, tags
        case esrbRating = "esrb_rating"
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case shortScreenshots = "short_screenshots"
        case parentPlatforms = "parent_platforms"
        case genres
    }
}

// MARK: - AddedByStatus
struct AddedByStatus: Decodable {
    let yet, owned, beaten, toplay: Int?
    let dropped, playing: Int?
}

enum Color: String, Decodable {
    case the0F0F0F = "0f0f0f"
}

// MARK: - EsrbRating
struct EsrbRating: Decodable {
    let id: Int?
    let name, slug, nameEn, nameRu: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case nameEn = "name_en"
        case nameRu = "name_ru"
    }
}

// MARK: - Genre
struct Genre: Decodable {
    let id: Int?
    let name, slug: String?
}

// MARK: - Platform
struct Platform: Decodable {
    let platform: Genre?
}

// MARK: - Rating
struct Rating: Decodable {
    let id: Int?
    let title: Title?
    let count: Int?
    let percent: Double?
}

enum Title: String, Decodable {
    case exceptional = "exceptional"
    case meh = "meh"
    case recommended = "recommended"
    case skip = "skip"
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Decodable {
    let id: Int?
    let image: String?
}

// MARK: - Store
struct Store: Decodable {
    let store: Genre?
}

// MARK: - Tag
struct Tag: Decodable {
    let id: Int?
    let name, slug: String?
    let language: Language?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

enum Language: String, Decodable {
    case eng = "eng"
    case rus = "rus"
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() { }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

