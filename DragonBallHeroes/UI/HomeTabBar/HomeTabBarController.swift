//
//  HomeTabBarController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 24/9/23.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()

            setupLayout()
            setupTabs()
        }

        private func setupTabs() {
            let navigationController1 = UINavigationController(rootViewController: ListHeroesTableViewController())
            let tabImage = UIImage(systemName: "house.fill")!
            navigationController1.tabBarItem = UITabBarItem(title: "Heroes", image: tabImage, tag: 0)


            viewControllers = [navigationController1]
        }

        private func setupLayout() {
            tabBar.backgroundColor = .systemBackground
        }

}
