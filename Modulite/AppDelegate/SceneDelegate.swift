//
//  SceneDelegate.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var router = SceneDelegateRouter(window: window!)
    lazy var coordinator = RootTabCoordinator(router: router)

    // MARK: - Handle Deeplink
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        _ = handleDeepLink(url: url)
    }

    private func handleDeepLink(url: URL) -> Bool {
        guard let scheme = url.scheme, scheme == "moduliteapp" else {
            print("Invalid URL scheme: \(url.scheme ?? "nil")")
            return false
        }

        guard let host = url.host(), host == "app" else {
            print("Invalid URL host: \(url.host() ?? "nil")")
            return false
        }
        
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let parameter = queryItems.first(where: { $0.name == "app" })?.value else {
            print("Invalid URLComponents query items.")
            return false
        }
        
        performOpenAppAction(with: parameter)
        return true
    }
    
    private func performOpenAppAction(with urlScheme: String) {
        print("Opening app with urlScheme: \(urlScheme)")
        UIApplication.shared.open(URL(string: urlScheme)!)

    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        coordinator.present(animated: true, onDismiss: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
