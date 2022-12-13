import Foundation
struct Matches: Codable, Identifiable {
    let id: Int?
    let season: Season?
    let utcDate: String?
    let status: String?
    let matchday: Int?
    let stage: String?
    let group: String?
    let lastUpdated: String?
    let odds: Odds?
    let score: Score?
    let homeTeam: HomeTeam?
    let awayTeam: AwayTeam?
    let referees: [Referees]?
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case season = "season"
        case utcDate = "utcDate"
        case status = "status"
        case matchday = "matchday"
        case stage = "stage"
        case group = "group"
        case lastUpdated = "lastUpdated"
        case odds = "odds"
        case score = "score"
        case homeTeam = "homeTeam"
        case awayTeam = "awayTeam"
        case referees = "referees"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        season = try values.decodeIfPresent(Season.self, forKey: .season)
        utcDate = try values.decodeIfPresent(String.self, forKey: .utcDate)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        matchday = try values.decodeIfPresent(Int.self, forKey: .matchday)
        stage = try values.decodeIfPresent(String.self, forKey: .stage)
        group = try values.decodeIfPresent(String.self, forKey: .group)
        lastUpdated = try values.decodeIfPresent(String.self, forKey: .lastUpdated)
        odds = try values.decodeIfPresent(Odds.self, forKey: .odds)
        score = try values.decodeIfPresent(Score.self, forKey: .score)
        homeTeam = try values.decodeIfPresent(HomeTeam.self, forKey: .homeTeam)
        awayTeam = try values.decodeIfPresent(AwayTeam.self, forKey: .awayTeam)
        referees = try values.decodeIfPresent([Referees].self, forKey: .referees)
    }
}
