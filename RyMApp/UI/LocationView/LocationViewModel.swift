//
//  LocationViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 16/4/24.
//

import Foundation
import Combine

final class LocationViewModel {
    // MARK: - Properties -
    @Published var model: Locations = []
    @Published var locations: AllLocations?
    @Published var pageCount = 1
    let otherPage = PassthroughSubject<Void, Error>()

    func initViewAndData() {
        NetworkApi.shared.getAllLocations() { [weak self] locations in
            self?.model = locations.results
            self?.locations = locations
            self?.otherPage.send()
        }
    }
    
    func nextPage() {
        NetworkApi.shared.pagesLocation(url: (locations?.info.next)! ) { [weak self] allLocations in
            self?.model = allLocations.results
            self?.locations = allLocations
            self?.pageCount += 1
           /* self?.backButton.isHidden = false
            if self?.model.info.next == nil {
                self?.nextButton.isHidden = true
            }*/
            self?.otherPage.send()
        }
    }
    
    func prevPage() {
        NetworkApi.shared.pagesLocation(url: (locations?.info.prev)!) { [weak self] allLocations in
            self?.model = allLocations.results
            self?.locations = allLocations
            self?.pageCount -= 1
            /*self?.nextButton.isHidden = false
            if self?.model.info.prev == nil {
                self?.backButton.isHidden = true
            }*/
            self?.otherPage.send()
        }
    }
}
