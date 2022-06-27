//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture
import Foundation

struct DirectionScreenContentState: Equatable {

    var items: IdentifiedArrayOf<Item>

    init(items: IdentifiedArrayOf<Item> = []) {
        self.items = items
    }
}
