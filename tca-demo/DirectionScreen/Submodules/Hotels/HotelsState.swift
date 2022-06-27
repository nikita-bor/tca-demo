//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

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
