//
//  LoadingViewController.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 21/11/24.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteTurnip

        let animationView = LottieAnimationView(name: "U_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        animationView.play()

        view.addSubview(animationView)
    }
}
