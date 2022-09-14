//
//  TabBarController.swift
//  Ably
//
//  Created by 김희진 on 2022/09/02.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var homeViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: HomeViewController())
        viewController.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return viewController
    }()
    
    private lazy var likeViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: LikeViewController())
        viewController.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .white
        tabBar.tintColor = .pointColor

        viewControllers = [homeViewController, likeViewController]
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
}

