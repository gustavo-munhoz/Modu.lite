//
//  Router.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

/// Defines the routing logic for presenting and dismissing view controllers.
protocol Router: AnyObject {
    /// Presents a view controller with an optional animation.
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - animated: Determines if the presentation should be animated.
    func present(_ viewController: UIViewController, animated: Bool)
    
    /// Presents a view controller with an optional animation and a dismissal handler.
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the view controller is dismissed.
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?)
    
    /// Dismisses the currently presented view controller with an optional animation.
    /// - Parameter animated: Determines if the dismissal should be animated.
    func dismiss(animated: Bool)
    
    func dismissTopViewController(animated: Bool)
}

/// Extension to provide default implementation for simpler presentation calls.
extension Router {
    /// Presents a view controller with an optional animation but without a dismissal handler.
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - animated: Determines if the presentation should be animated.
    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismiss: nil)
    }
}
