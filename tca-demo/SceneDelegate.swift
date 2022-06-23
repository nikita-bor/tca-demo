//
//  Created by Nikita Borodulin on 23.06.2022.
//

import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let contentView = DirectionScreenView(
            store: .init(
                initialState: .init(),
                reducer: directionScreenReducer,
                environment: .live
            )
        )
        let windowScene = scene as! UIWindowScene
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
    }
}
