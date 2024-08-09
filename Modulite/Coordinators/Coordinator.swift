//
//  Coordinator.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 09/08/24.
//

import UIKit

/// Represents an object that coordinates flow between view controllers.
protocol Coordinator: AnyObject {
    /// A collection of child coordinators to retain a hierarchy.
    var children: [Coordinator] { get set }
    
    /// The router responsible for presenting and dismissing view controllers.
    var router: Router { get }
    
    /// Presents a view controller managed by the coordinator.
    /// - Parameters:
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the view controller is dismissed.
    func present(animated: Bool, onDismiss: (() -> Void)?)
    
    /// Dismisses the view controller managed by the coordinator.
    /// - Parameter animated: Determines if the dismissal should be animated.
    func dismiss(animated: Bool)
    
    /// Presents a child coordinator.
    /// - Parameters:
    ///   - child: The child coordinator to present.
    ///   - animated: Determines if the presentation should be animated.
    func presentChild(_ child: Coordinator, animated: Bool)
    
    /// Presents a child coordinator and provides a closure to handle when it's dismissed.
    /// - Parameters:
    ///   - child: The child coordinator to present.
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the child coordinator is dismissed.
    func presentChild(_ child: Coordinator, animated: Bool, onDismiss: (() -> Void)?)
}

/// Default implementations of some `Coordinator` methods.
extension Coordinator {
    /// Dismisses the view controller managed by the coordinator with an optional animation.
    /// - Parameter animated: Determines if the dismissal should be animated.
    func dismiss(animated: Bool) {
        router.dismiss(animated: animated)
    }
    
    /// Presents a child coordinator with an optional animation but without a dismissal handler.
    /// - Parameters:
    ///   - child: The child coordinator to present.
    ///   - animated: Determines if the presentation should be animated.
    func presentChild(_ child: Coordinator, animated: Bool) {
        presentChild(child, animated: animated, onDismiss: nil)
    }
    
    /// Presents a child coordinator with an optional animation and a dismissal handler.
    /// - Parameters:
    ///   - child: The child coordinator to present.
    ///   - animated: Determines if the presentation should be animated.
    ///   - onDismiss: Optional closure to execute when the child coordinator is dismissed.
    func presentChild(_ child: Coordinator, animated: Bool, onDismiss: (() -> Void)?) {
        children.append(child)
        
        child.present(animated: animated) { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            
            self.removeChild(child)
            onDismiss?()
        }
    }
    
    /// Removes a child coordinator from the hierarchy.
    /// - Parameter child: The child coordinator to remove.
    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child }) else { return }
        children.remove(at: index)
    }
}
