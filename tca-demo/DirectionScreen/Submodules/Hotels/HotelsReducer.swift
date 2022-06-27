//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

enum HotelsAction: Equatable {
    case selectHotel(DirectionHotel.ID)
    case toggleHideExpensiveHotels(Bool)
}

struct HotelsEnvironment {
    var trackStatisticsEvent: (StatisticsEvent) -> Effect<Void, Never>
}

let hotelsReducer = Reducer<HotelsState, HotelsAction, HotelsEnvironment> { state, action, environment in
    switch action {
        case .selectHotel(let hotelID):
            guard let hotel = state.hotels[id: hotelID] else {
                return .none
            }
            print("hotelsReducer handles .selectHotel")
            return environment.trackStatisticsEvent(.init()).fireAndForget()
        case .toggleHideExpensiveHotels(let shouldHide):
            state.hidesExpensiveHotels = shouldHide
            return .none
    }
}
