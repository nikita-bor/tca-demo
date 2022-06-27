//
//  Created by Nikita Borodulin on 23.06.2022.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct DirectionScreenView: View {

    let store: Store<DirectionScreenState, DirectionScreenAction>

    var body: some View {
        WithViewStore(store.scope(state: \.title)) { viewStore in
            NavigationView {
                ScrollView {
                    SwitchStore(store.scope(state: \.loadingState)) {
                        CaseLet(state: /DirectionScreenState.LoadingState.loading, then: LoadingView.init)
                        CaseLet(state: /DirectionScreenState.LoadingState.loaded, action: DirectionScreenAction.content, then: DirectionScreenContentView.init)
                        CaseLet(state: /DirectionScreenState.LoadingState.placeholder, then: PlaceholderView.init)
                    }
                }
                .onAppear { viewStore.send(.onAppear) }
                .navigationBarTitle(viewStore.state)
            }
        }
    }
}

private struct PlaceholderView: View {

    let store: Store<Void, DirectionScreenAction>

    var body: some View {
        Text("Something went wrong")
    }
}


private struct LoadingView: View {

    let store: Store<Void, DirectionScreenAction>

    var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView()
        }
    }
}
