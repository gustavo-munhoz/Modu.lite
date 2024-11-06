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

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        coordinator.present(animated: true, onDismiss: nil)
        
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(url: url)
        }
    }

    // MARK: - Handle Deeplink
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        handleDeepLink(url: url)
    }

    @discardableResult
    func handleDeepLink(url: URL) -> Bool {
        guard let scheme = url.scheme, scheme == "moduliteapp" else {
            print("Invalid URL scheme: \(url.scheme ?? "nil")")
            return false
        }

        guard let host = url.host, host == "app" else {
            print("Invalid URL host: \(url.host ?? "nil")")
            return false
        }
        
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let parameter = queryItems.first(where: { $0.name == "app" })?.value else {
            print("Invalid URLComponents query items.")
            return false
        }
        
        let redirectingVC = RedirectingViewController()
        redirectingVC.modalPresentationStyle = .fullScreen
        
        if let rootVC = window?.rootViewController {
            rootVC.present(redirectingVC, animated: false)
        }
        
        performOpenAppAction(with: "someAppURLScheme") { result in
            switch result {
            case .success(let message):
                print(message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    redirectingVC.dismiss(animated: false)
                }
            case .failure(let error):
                if let appOpenError = error as? AppOpenError {
                    switch appOpenError {
                    case .invalidURL:
                        print("URL inválido fornecido.")
                        redirectingVC.showAlert {
                            redirectingVC.dismiss(animated: true)
                        }
                    case .cannotOpenApp:
                        print("Can't open app")
                        redirectingVC.showAlert {
                            redirectingVC.dismiss(animated: true)
                        }
                    }
                } else {
                    print("Erro desconhecido: \(error.localizedDescription)")
                }
            }
        }
        
        return true
    }

    private func performOpenAppAction(with urlScheme: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Opening app with urlScheme: \(urlScheme)")
        
        if let url = URL(string: urlScheme) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { success in
                    if success {
                        completion(.success("Opened app"))
                    } else {
                        completion(.failure(AppOpenError.cannotOpenApp))
                    }
                }
            } else {
                completion(.failure(AppOpenError.cannotOpenApp))
            }
        } else {
            completion(.failure(AppOpenError.invalidURL))
        }
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

enum AppOpenError: Error {
    case invalidURL
    case cannotOpenApp
}
