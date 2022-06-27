//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

enum TicketsAction: Equatable {
    case selectTicket(DirectionTicket.ID)
    case toggleSpecialMode(Bool)
}

struct TicketsEnvironment {
    var trackStatisticsEvent: (StatisticsEvent) -> Effect<Void, Never>
}

let ticketsReducer = Reducer<TicketsState, TicketsAction, TicketsEnvironment> { state, action, environment in
    switch action {
        case .selectTicket(let ticketID):
            print("ticketsReducer handles .selectTicket")
            guard let ticket = state.tickets[id: ticketID] else {
                return .none
            }
            return environment.trackStatisticsEvent(.init()).fireAndForget()
        case .toggleSpecialMode(let isEnabled):
            state.isSpecialModeEnabled = isEnabled
            return .none
    }
}
