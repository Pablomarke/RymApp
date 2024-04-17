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
    @Published var model: AllLocations
    @Published var pageCount = 1
    let otherPage = PassthroughSubject<Void, Error>()

    // MARK: - Init -
    init( model: AllLocations) {
        self.model = model
        
    }
    
    func initViewAndData() {
        NetworkApi.shared.getAllLocations() { locations in
            
        }
    }
    
    func nextPage() {
        NetworkApi.shared.pagesLocation(url: (model.info.next)! ) { [weak self] AllLocations in
            self?.model = AllLocations
            self?.pageCount += 1
           /* self?.backButton.isHidden = false
            if self?.model.info.next == nil {
                self?.nextButton.isHidden = true
            }*/
            self?.otherPage.send()
        }
    }
    
    func prevPage() {
        NetworkApi.shared.pagesLocation(url: (model.info.prev)!) { [weak self] AllLocations in
            self?.model = AllLocations
            self?.pageCount -= 1
            /*self?.nextButton.isHidden = false
            if self?.model.info.prev == nil {
                self?.backButton.isHidden = true
            }*/
            self?.otherPage.send()
        }
    }
}
