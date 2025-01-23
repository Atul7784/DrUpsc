struct UnsplashImage: Decodable, Equatable {
    let id: String
    let url: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case urls
        case description
    }

    enum URLKeys: String, CodingKey {
        case regular
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        let urlsContainer = try container.nestedContainer(keyedBy: URLKeys.self, forKey: .urls)
        url = try urlsContainer.decode(String.self, forKey: .regular)
    }
}
