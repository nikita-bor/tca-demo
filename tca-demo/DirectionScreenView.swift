//
//  Created by Nikita Borodulin on 23.06.2022.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct DirectionScreenState: Equatable {
    var items: IdentifiedArrayOf<Item>
    var response: DirectionScreenResponse?

    init(
        items: IdentifiedArrayOf<Item> = [],
        response: DirectionScreenResponse? = nil
    ) {
        self.items = items
        self.response = response
    }
}

enum DirectionScreenAction {
    case item(id: Item.ID, action: ItemAction)
    case loadingResponse(Result<DirectionScreenResponse, Error>)
    case onAppear
}

struct DirectionScreenEnvironment {
    var fetchItems: () -> Effect<DirectionScreenResponse, Error>
    var trackStatisticsEvent: (StatisticsEvent) -> Effect<Void, Never>
}

extension DirectionScreenEnvironment {

    static let live = Self(
        fetchItems: { .init(value: .mock) },
        trackStatisticsEvent: { _ in .none }
    )
}

let directionScreenReducer = Reducer<DirectionScreenState, DirectionScreenAction, DirectionScreenEnvironment>.combine(
    itemReducer.forEach(
        state: \.items,
        action: /DirectionScreenAction.item(id:action:),
        environment: {
            .init(trackStatisticsEvent: $0.trackStatisticsEvent)
        }
    ),
    .init { state, action, environment in

        func parseItems(from response: DirectionScreenResponse) -> [Item] {
            response.items.compactMap { responseItem in
                switch responseItem.block {
                    case .hotels(let hotelsResponse):
                        return .hotels(
                            .init(
                                id: responseItem.id,
                                hotels: .init(uniqueElements: hotelsResponse.hotels.map(DirectionHotel.init)))
                        )
                    case .tickets(let ticketsResponse):
                        return .tickets(
                            .init(
                                id: responseItem.id,
                                tickets: .init(uniqueElements: ticketsResponse.tickets.map(DirectionTicket.init))
                            )
                        )
                    case .unknown:
                        return nil
                }
            }
        }

        switch action {
            case .item(_, action: .hotels(.selectHotel(let hotelID))):
                print("directionScreenReducer handles .hotels(.selectHotel)")
                return .none
            case .item(_, action: .tickets(.toggleSpecialMode(let isSpecialModeEnabled))):
                guard
                    let hotelsItemID = state.items.first(where: {
                        if case .hotels = $0 {
                            return true
                        } else {
                            return false
                        }
                    })
                else {
                    return .none
                }

                return Effect(
                    value: .item(
                        id: hotelsItemID.id,
                        action: .hotels(.toggleHideExpensiveHotels(isSpecialModeEnabled))
                    )
                )
            case .item:
                return .none
            case .loadingResponse(.failure):
                return .none
            case .loadingResponse(.success(let response)):
                state.items = .init(uniqueElements: parseItems(from: response))
                return .none
            case .onAppear:
                return environment.fetchItems()
                    .catchToEffect(DirectionScreenAction.loadingResponse)
        }
    }
)

struct DirectionScreenView: View {

    let store: Store<DirectionScreenState, DirectionScreenAction>

    var body: some View {
        WithViewStore(store.stateless) { viewStore in
            NavigationView {
                ScrollView {
                    VStack(spacing: 32) {
                        ForEachStore(
                            store.scope(
                                state: \.items,
                                action: DirectionScreenAction.item(id:action:)
                            )
                        )
                        {
                            ItemView(store: $0)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear { viewStore.send(.onAppear) }
                .navigationBarTitle("DirectionScreen")
            }
        }
    }
}
