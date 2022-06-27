//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

struct DirectionScreenState: Equatable {

    enum LoadingState: Equatable {
        case loaded(DirectionScreenContentState)
        case loading
        case placeholder
    }

    var loadingState: LoadingState
    var title: String

    init(
        loadingState: LoadingState = .loading,
        title: String = ""
    ) {
        self.loadingState = loadingState
        self.title = title
    }
}

enum DirectionScreenAction {
    case content(DirectionScreenContentAction)
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
    directionScreenContentReducer
        .pullback(state: /DirectionScreenState.LoadingState.loaded, action: /DirectionScreenAction.content, environment: { $0 })
        .pullback(state: \.loadingState, action: /.self, environment: { $0 }),
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
            case .content:
                return .none
            case .loadingResponse(.failure):
                state.loadingState = .placeholder
                return .none
            case .loadingResponse(.success(let response)):
                state.loadingState = .loaded(.init(items: .init(uniqueElements: parseItems(from: response))))
                return .none
            case .onAppear:
                state.title = "Direction Screen"
                return environment.fetchItems()
                    .deferred(for: 1, scheduler: DispatchQueue.main)
                    .catchToEffect(DirectionScreenAction.loadingResponse)
        }
    }
)
