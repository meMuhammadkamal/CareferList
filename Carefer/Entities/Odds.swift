import Foundation
struct Odds: Codable {
	let msg: String?

	enum CodingKeys: String, CodingKey {

		case msg = "msg"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		msg = try values.decodeIfPresent(String.self, forKey: .msg)
	}

}
