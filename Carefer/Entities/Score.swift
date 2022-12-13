import Foundation
struct Score: Codable {
	let winner: String?
	let duration: String?
	let fullTime: FullTime?
	let halfTime: HalfTime?
	let extraTime: ExtraTime?
	let penalties: Penalties?

	enum CodingKeys: String, CodingKey {

		case winner = "winner"
		case duration = "duration"
		case fullTime = "fullTime"
		case halfTime = "halfTime"
		case extraTime = "extraTime"
		case penalties = "penalties"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		winner = try values.decodeIfPresent(String.self, forKey: .winner)
		duration = try values.decodeIfPresent(String.self, forKey: .duration)
		fullTime = try values.decodeIfPresent(FullTime.self, forKey: .fullTime)
		halfTime = try values.decodeIfPresent(HalfTime.self, forKey: .halfTime)
		extraTime = try values.decodeIfPresent(ExtraTime.self, forKey: .extraTime)
		penalties = try values.decodeIfPresent(Penalties.self, forKey: .penalties)
	}

}
