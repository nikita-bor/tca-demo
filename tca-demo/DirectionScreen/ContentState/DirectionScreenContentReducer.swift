//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture

enum DirectionScreenContentAction {
    case item(id: Item.ID, action: ItemAction)
}

let directionScreenContentReducer = Reducer<DirectionScreenContentState, DirectionScreenContentAction, DirectionScreenEnvironment>.combine(
    itemReducer
        .forEach(
            state: \.items,
            action: /DirectionScreenContentAction.item(id:action:),
            environment: {
                .init(trackStatisticsEvent: $0.trackStatisticsEvent)
            }
        ),
    .init { state, action, environment in

        switch action {
            case .item(_, action: .hotels(.selectHotel(let hotelID))):
                print("directionScreenReducer handles .hotels(.selectHotel)")
                return .none
            case .item(_, action: .tickets(.toggleSpecialMode(let isSpecialModeEnabled))):
                guard let hotelsItemID = state.items.first(where: {
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
        }
    }
)
