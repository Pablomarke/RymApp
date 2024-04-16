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
    private var episodes: Episodes = []
    let episode = PassthroughSubject<Void, Error>()

    init(model: Character) {
        self.model = model
    }
    
    func initViewAndChargeData() {
        getEpisodes()
    }
    
    func getEpisodeBy(index: Int) -> Episode {
        episodes[index]
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
