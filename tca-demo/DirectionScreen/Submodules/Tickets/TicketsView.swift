//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture
import SwiftUI

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
