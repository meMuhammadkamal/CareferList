import Foundation
struct MatchesList: Codable {
	let count: Int?
	let filters: Filters?
	let competition: Competition?
	let matches: [Matches]?

	enum CodingKeys: String, CodingKey {

		case count = "count"
		case filters = "filters"
		case competition = "competition"
		case matches = "matches"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
		filters = try values.decodeIfPresent(Filters.self, forKey: .filters)
		competition = try values.decodeIfPresent(Competition.self, forKey: .competition)
		matches = try values.decodeIfPresent([Matches].self, forKey: .matches)
	}
}
