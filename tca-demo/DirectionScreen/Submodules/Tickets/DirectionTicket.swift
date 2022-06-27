//
//  Created by Nikita Borodulin on 25.06.2022.
//

import Foundation

struct DirectionTicket: Equatable, Identifiable {
    let id: String
    let price: String
}

extension DirectionTicket {

    init(response: TicketsResponse.Ticket) {
        self.id = response.id
        self.price = response.price
    }
}
