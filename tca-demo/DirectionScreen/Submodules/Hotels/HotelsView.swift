//
//  Created by Nikita Borodulin on 23.06.2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

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
