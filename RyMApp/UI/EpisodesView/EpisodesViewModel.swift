//
//  EpisodesViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 17/4/24.
//

import Foundation
import Combine
import UIKit

final class EpisodesViewModel {
    // MARK: - Properties -
    var model: Episodes = []
    var reloadData = PassthroughSubject<Void, Never>()
    
    func initDataView() {
        self.createItem(season: Seasons.season1)
    }
    
    func createItem(season: String) {
        NetworkApi.shared.getArrayEpisodes(season: season) { [weak self] episodes in
            self?.model = episodes
            self?.reloadData.send()
        }
    }
}
