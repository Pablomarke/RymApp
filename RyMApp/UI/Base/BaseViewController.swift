//
//  BaseViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 30/3/24.
//

import UIKit

class BaseViewController: UIViewController {
    func createTabBar(tabBar: UITabBar) {
        tabBar.delegate = self
        tabBar.tintColor = Color.secondColor
        tabBar.barTintColor = Color.mainColor
        tabBar.isTranslucent = false
    }
}

// MARK: - UItabBar -
extension BaseViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar,
                didSelect item: UITabBarItem) {
        TabBarManager.handleTabBarItemSelection(for: item,
                                                navigationController: self.navigationController!)
    }
}
