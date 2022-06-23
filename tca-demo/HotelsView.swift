//
//  Created by Nikita Borodulin on 23.06.2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct HotelsState: Equatable, Identifiable {

    let id: String
    var hotels: IdentifiedArrayOf<DirectionHotel>
    var hidesExpensiveHotels = false

    var filteredHotels: IdentifiedArrayOf<DirectionHotel> {
        if hidesExpensiveHotels {
            return hotels.filter { !$0.isExpensive }
        } else {
            return hotels
        }
    }

    init(
        id: String,
        hidesExpensiveHotels: Bool = false,
        hotels: IdentifiedArrayOf<DirectionHotel>
    ) {
        self.id = id
        self.hidesExpensiveHotels = hidesExpensiveHotels
        self.hotels = hotels
    }
}

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

struct HotelsView: View {

    let store: Store<HotelsState, HotelsAction>

    var body: some View {
        VStack(alignment: .leading) {
            Text("Hotels")
                .font(.headline)
                .padding(.horizontal, 12)
            ScrollView(.horizontal) {
                WithViewStore(store) { viewStore in
                    HStack {
                        ForEach(viewStore.filteredHotels) { hotel in
                            HotelView(hotel: hotel, onTap: {
                                viewStore.send(.selectHotel(hotel.id))
                            })
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .animation(.easeOut(duration: 1))
            }
        }
    }
}

struct HotelView: View {
    let hotel: DirectionHotel
    let onTap: () -> Void

    var body: some View {
        VStack {
            Color.yellow
                .frame(width: 100, height: 120)
                .clipped()
                .cornerRadius(12)
            Text(hotel.title)
                .font(.body)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct DirectionHotel: Equatable, Identifiable {
    let id: String
    let isExpensive: Bool
    let title: String
}

extension DirectionHotel {

    init(response: HotelsResponse.Hotel) {
        self.id = response.id
        self.isExpensive = response.isExpensive
        self.title = response.title
    }
}
