//
//  Created by Nikita Borodulin on 23.06.2022.
//

import Foundation

struct DirectionScreenResponse: Decodable, Equatable {

    struct Item: Equatable {

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case block
            case blockContextId
            case blockContext
            case order
        }

        enum Block: Equatable {
            case hotels(HotelsResponse)
            case tickets(TicketsResponse)
            case unknown
        }

        let id: String
        let block: Block
        let type: String
    }
    

    let items: [Item]
}

struct HotelsResponse: Decodable, Equatable {

    struct Hotel: Decodable, Equatable {

        let id: String
        let isExpensive: Bool
        let title: String
    }

    let hotels: [Hotel]
}

struct TicketsResponse: Decodable, Equatable {

    struct Ticket: Decodable, Equatable {

        let id: String
        let price: String
    }

    let tickets: [Ticket]
}

extension DirectionScreenResponse.Item: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        switch type {
            case "hotels":
                block = .hotels(try container.decode(HotelsResponse.self, forKey: .block))
            case "tickets":
                block = .tickets(try container.decode(TicketsResponse.self, forKey: .block))
            default:
                block = .unknown
        }
    }
}

extension DirectionScreenResponse {

    static var mock: Self = .init(
        items: [
            .init(
                id: "1",
                block: .hotels(
                    .init(
                        hotels: [
                            .init(id: "1", isExpensive: false, title: "First Hotel"),
                            .init(id: "2", isExpensive: true, title: "Second Hotel")
                        ]
                    )
                ),
                type: "hotels"
            ),
            .init(
                id: "2",
                block: .tickets(
                    .init(
                        tickets: [
                            .init(id: "1", price: "$100"),
                            .init(id: "2", price: "$200")
                        ]
                    )
                ),
                type: "tickets"
            )
        ]
    )
}
