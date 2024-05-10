//
//  CharacterDetailViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 16/4/24.
//

import Foundation
import Combine

final class CharacterDetailViewModel {
    @Published var model: Character
    @Published var episodes: Episodes = []
    let episode = PassthroughSubject<Void, Error>()

    init(model: Character) {
        self.model = model
    }
    
    func initViewAndChargeData() {
        getEpisodes()
    }
}

private extension CharacterDetailViewModel {
    func getEpisodes() {
        for i in model.episode {
            NetworkApi.shared.getEpisode(url: i) { episode in
                self.episodes.append(episode)
                self.episode.send()
            }
        }
    }
}
