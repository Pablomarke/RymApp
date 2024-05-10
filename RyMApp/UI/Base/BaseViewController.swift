//
//  BaseViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 30/3/24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    // MARK: - Properties -
    var cancellables = Set<AnyCancellable>()
    
    func createTabBar(tabBar: UITabBar) {
        tabBar.delegate = self
        tabBar.tintColor = Color.secondColor
        tabBar.barTintColor = Color.mainColor
        tabBar.isTranslucent = false
    }
    
    func viewStyle(title: String) {
        self.view.backgroundColor = Color.mainColor
        navigationItem.title = title
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
    }
    
    func createViewForData(label: UILabel, view: UIView, view2: UIView, title: String) {
        view.cornerToView()
        view2.cornerToView()
        label.textColor = Color.mainColor
        label.text = title
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
