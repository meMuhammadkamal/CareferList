import Foundation
struct ExtraTime: Codable {
	let homeTeam: String?
	let awayTeam: String?

	enum CodingKeys: String, CodingKey {

		case homeTeam = "homeTeam"
		case awayTeam = "awayTeam"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		homeTeam = try values.decodeIfPresent(String.self, forKey: .homeTeam)
		awayTeam = try values.decodeIfPresent(String.self, forKey: .awayTeam)
	}

}
