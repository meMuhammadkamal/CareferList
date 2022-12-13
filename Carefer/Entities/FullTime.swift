import Foundation
struct FullTime: Codable {
	let homeTeam: Int?
	let awayTeam: Int?

	enum CodingKeys: String, CodingKey {

		case homeTeam = "homeTeam"
		case awayTeam = "awayTeam"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		homeTeam = try values.decodeIfPresent(Int.self, forKey: .homeTeam)
		awayTeam = try values.decodeIfPresent(Int.self, forKey: .awayTeam)
	}

}
