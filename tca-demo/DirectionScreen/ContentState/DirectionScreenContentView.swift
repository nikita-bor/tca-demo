//
//  Created by Nikita Borodulin on 25.06.2022.
//

import ComposableArchitecture
import SwiftUI

struct DirectionScreenContentView: View {

    let store: Store<DirectionScreenContentState, DirectionScreenContentAction>

    var body: some View {
        VStack(spacing: 32) {
            ForEachStore(
                store.scope(
                    state: (\.items),
                    action: DirectionScreenContentAction.item(id:action:)
                )
            )
            {
                ItemView(store: $0)
            }
        }
    }
}
