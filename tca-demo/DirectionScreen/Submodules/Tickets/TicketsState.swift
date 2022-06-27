//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

struct TicketsState: Equatable, Identifiable {

    let id: String
    let tickets: IdentifiedArrayOf<DirectionTicket>
    var isSpecialModeEnabled: Bool

    init(
        id: String = "",
        tickets: IdentifiedArrayOf<DirectionTicket> = [],
        isSpecialModeEnabled: Bool = false
    ) {
        self.id = id
        self.tickets = tickets
        self.isSpecialModeEnabled = isSpecialModeEnabled
    }
}
