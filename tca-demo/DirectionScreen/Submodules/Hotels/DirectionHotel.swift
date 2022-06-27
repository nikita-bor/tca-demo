//
//  Created by Nikita Borodulin on 25.06.2022.
//

import Foundation

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
