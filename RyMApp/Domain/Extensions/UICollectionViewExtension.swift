//
//  UICollectionViewExtension.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 5/12/23.
//

import UIKit

extension UICollectionView {
    func clearBackground(){
        self.backgroundColor = UIColor.clear
        self.backgroundView = UIView.init(frame: CGRect.zero)
    }
    
    func rymCollectionStyle(cellIdentifier: String) {
        self.clearBackground()
        self.register(UINib( nibName: cellIdentifier,
                                             bundle: nil),
                                      forCellWithReuseIdentifier: cellIdentifier)
    }
}
