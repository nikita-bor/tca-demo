//
//  Created by Nikita Borodulin on 23.06.2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

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

struct TicketsView: View {

    let store: Store<TicketsState, TicketsAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Toggle(
                    "Special Mode",
                    isOn: viewStore.binding(
                        get: \.isSpecialModeEnabled,
                        send: TicketsAction.toggleSpecialMode
                    )
                )
                .padding(.horizontal, 12)
                Text("Tickets")
                    .font(.headline)
                    .padding(.horizontal, 12)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewStore.tickets) { ticket in
                            TicketView(ticket: ticket, onTap: {
                                viewStore.send(.selectTicket(ticket.id))
                            })
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .background(Color.pink.opacity(0.3))
        }
    }
}

struct TicketView: View {
    let ticket: DirectionTicket
    let onTap: () -> Void

    var body: some View {
        VStack {
            Color.blue
                .frame(width: 100, height: 120)
                .clipped()
                .cornerRadius(12)

            Text(ticket.price)
                .font(.subheadline)
                .opacity(0.7)
                .lineLimit(2)
        }
        .onTapGesture {
            onTap()
        }
    }
}

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
