//
//  Games.swift
//  GameList
//
//  Created by Melik Demiray on 18.05.2024.
//

import Foundation

// MARK: - GameModel
struct GameModel: Decodable {
    let count: Int?
    let next: String?
    let previous: JSONNull?
    let results: [Results]?
    let seoTitle, seoDescription, seoKeywords, seoH1: String?
    let noindex, nofollow: Bool?
    let description: String?
    let filters: Filters?
    let nofollowCollections: [String]?

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case seoTitle = "seo_title"
        case seoDescription = "seo_description"
        case seoKeywords = "seo_keywords"
        case seoH1 = "seo_h1"
        case noindex, nofollow, description, filters
        case nofollowCollections = "nofollow_collections"
    }
}

// MARK: - Filters
struct Filters: Decodable {
    let years: [FiltersYear]?
}

// MARK: - FiltersYear
struct FiltersYear: Decodable {
    let from, to: Int?
    let filter: String?
    let decade: Int?
    let years: [YearYear]?
    let nofollow: Bool?
    let count: Int?
}

// MARK: - YearYear
struct YearYear: Decodable {
    let year, count: Int?
    let nofollow: Bool?
}

// MARK: - Results
struct Results: Decodable {
    let id: Int?
    let slug, name, released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount, reviewsTextCount, added: Int?
    let addedByStatus: AddedByStatus?
    let metacritic, playtime, suggestionsCount: Int?
    let updated: String?
    let userGame: JSONNull?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: Color?
    let platforms: [PlatformElement]?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let stores: [Store]?
    let clip: JSONNull?
    let tags: [Genre]?
    let esrbRating: EsrbRating?
    let shortScreenshots: [ShortScreenshot]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case platforms
        case parentPlatforms = "parent_platforms"
        case genres, stores, clip, tags
        case esrbRating = "esrb_rating"
        case shortScreenshots = "short_screenshots"
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
    let name, slug: String?
}

// MARK: - Genre
struct Genre: Decodable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: Domain?
    let language: Language?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case domain, language
    }
}

enum Domain: String, Decodable {
    case appsAppleCOM = "apps.apple.com"
    case epicgamesCOM = "epicgames.com"
    case gogCOM = "gog.com"
    case marketplaceXboxCOM = "marketplace.xbox.com"
    case microsoftCOM = "microsoft.com"
    case nintendoCOM = "nintendo.com"
    case playGoogleCOM = "play.google.com"
    case storePlaystationCOM = "store.playstation.com"
    case storeSteampoweredCOM = "store.steampowered.com"
}

enum Language: String, Decodable {
    case eng = "eng"
}

// MARK: - ParentPlatform
struct ParentPlatform: Decodable {
    let platform: EsrbRating?
}

// MARK: - PlatformElement
struct PlatformElement: Decodable {
    let platform: PlatformPlatform?
    let releasedAt: String?
    let requirementsEn, requirementsRu: Requirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirementsEn = "requirements_en"
        case requirementsRu = "requirements_ru"
    }
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Decodable {
    let id: Int?
    let name, slug: String?
    let image, yearEnd: JSONNull?
    let yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case yearEnd = "year_end"
        case yearStart = "year_start"
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

// MARK: - Requirements
struct Requirements: Decodable {
    let minimum, recommended: String?
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
    let id: Int?
    let store: Genre?
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