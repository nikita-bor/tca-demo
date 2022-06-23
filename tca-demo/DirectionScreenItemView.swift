//
//  Created by Nikita Borodulin on 23.06.2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum Item: Equatable, Identifiable {

    case hotels(HotelsState)
    case tickets(TicketsState)

    var id: String {
        switch self {
            case .hotels(let hotelsState):
                return hotelsState.id
            case .tickets(let ticketsState):
                return ticketsState.id
        }
    }
}

enum ItemAction: Equatable {
    case hotels(HotelsAction)
    case tickets(TicketsAction)
}

struct ItemEnvironment {
    var trackStatisticsEvent: (StatisticsEvent) -> Effect<Void, Never>
}

let itemReducer = Reducer<Item, ItemAction, ItemEnvironment>.combine(
    hotelsReducer.pullback(
        state: /Item.hotels,
        action: /ItemAction.hotels,
        environment: {
            .init(trackStatisticsEvent: $0.trackStatisticsEvent)
        }
    ),
    ticketsReducer.pullback(
        state: /Item.tickets,
        action: /ItemAction.tickets,
        environment: {
            .init(trackStatisticsEvent: $0.trackStatisticsEvent)
        }
    ),
    .init { state, action, environment in
        switch action {
            case .hotels(.selectHotel(let hotelID)):
                print("itemReducer handles .hotels(.selectHotel)")
                return .none
            case .tickets(.selectTicket(let ticketID)):
                print("itemReducer handles .ticket(.selectTicket)")
                return .none
            case .hotels:
                return .none
            case .tickets:
                return .none
        }
    }
)

struct ItemView: View {

    let store: Store<Item, ItemAction>

    var body: some View {
        SwitchStore(store) {
            CaseLet(
                state: /Item.hotels,
                action: ItemAction.hotels
            ) {
                HotelsView(store: $0)
            }
            CaseLet(
                state: /Item.tickets,
                action: ItemAction.tickets
            ) {
                TicketsView(store: $0)
            }
        }
    }
}
