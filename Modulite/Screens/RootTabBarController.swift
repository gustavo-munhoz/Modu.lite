//
//  RootTabBarController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 12/08/24.
//

import UIKit

protocol RootTabBarControllerDelegate: AnyObject {
    func rootTabBarControllerDidRequestScreenTime(
        _ viewController: RootTabBarController,
        in type: ScreenTimeRequestType
    )
}

extension RootTabBarController {
    static func instantiate(delegate: RootTabBarControllerDelegate) -> Self {
        let vc = Self()
        vc.requestDelegate = delegate
        
        return vc
    }
}

class RootTabBarController: UITabBarController {

    private let circleLayer = CAShapeLayer()
    private var tabBarFrameObserver: NSKeyValueObservation?

    weak var requestDelegate: RootTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .potatoYellow
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.fiestaGreen
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        setupCircleLayer()
        delegate = self

        DispatchQueue.main.async {
            self.updateCirclePosition(for: self.selectedIndex)
        }
        
        tabBarFrameObserver = tabBar.observe(\.frame, options: [.new]) { [weak self] (_, _) in
            self?.updateTabBarItemImagePositions()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTabBarItemImagePositions()
    }

    private func setupCircleLayer() {
        circleLayer.fillColor = getColorForSelectedTag().cgColor
        tabBar.layer.insertSublayer(circleLayer, below: nil)
    }
    
    private func getColorForSelectedTag() -> UIColor {
        switch tabBar.selectedItem?.tag {
        case 0: return UIColor.fiestaGreen
        case 1: return UIColor.carrotOrange
        case 2: return UIColor.ketchupRed
        case 3: return UIColor.blueberry
        default: return UIColor.clear
        }
    }

    private func updateCirclePosition(for index: Int) {
        guard let tabBarItems = tabBar.items, index < tabBarItems.count else { return }
        
        let numberOfItems = CGFloat(tabBarItems.count)
        let tabBarWidth = tabBar.bounds.width / numberOfItems
        let centerX = tabBarWidth * CGFloat(index) + tabBarWidth / 2
        let iconCenterY = tabBar.bounds.midY - (tabBar.bounds.height / 2)
        let radius: CGFloat = 27.5

        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: centerX, y: iconCenterY),
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.shadowOpacity = 0.2
        circleLayer.shadowOffset = CGSize(width: 1, height: 1)
        circleLayer.shadowRadius = 2
        
        let newFillColor = getColorForSelectedTag().cgColor
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.circleLayer.fillColor = newFillColor
            self.circleLayer.path = circlePath.cgPath
        }
    }
    
    private func updateTabBarItemImagePositions() {
        guard let tabBarItems = tabBar.items else { return }
        
        for tabBarItem in tabBarItems {
            guard let viewTabBar = tabBarItem.value(forKey: "view") as? UIView,
                  let imageView = viewTabBar.subviews.first(where: { $0 is UIImageView }) as? UIImageView,
                  tabBarItem == tabBar.selectedItem else { continue }
            
            UIView.animate(
                withDuration: 0.25,
                delay: .zero,
                options: .curveEaseOut
            ) {
                imageView.frame.origin.y = -15
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension RootTabBarController: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: self.getColorForSelectedTag(),
            .font: UIFont(textStyle: .footnote, weight: .bold)
        ]
        
        tabBar.scrollEdgeAppearance?.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: self.getColorForSelectedTag(),
            .font: UIFont(textStyle: .footnote, weight: .bold)
        ]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.updateTabBarItemImagePositions()
            if let index = tabBar.items?.firstIndex(of: item) {
                self.updateCirclePosition(for: index)
            }
        }
        
        requestScreenTimeIfNeeded(for: item)
    }
    
    private func requestScreenTimeIfNeeded(for item: UITabBarItem) {
        guard !UserPreference<ScreenTime>.shared.bool(for: .hasSetPreferenceBefore) else {
            return
        }
        
        switch item.tag {
        case 1:
            requestDelegate?.rootTabBarControllerDidRequestScreenTime(
                self, in: .usage
            )
        case 2:
            requestDelegate?.rootTabBarControllerDidRequestScreenTime(
                self, in: .appBlocking
            )
        default:
            return
        }
    }
}
