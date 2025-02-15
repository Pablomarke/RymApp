//
//  Network.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 27/7/23.
//

import Foundation

final class NetworkApi {
    static let shared = NetworkApi()
    private let cstatusOk = 200
    private let baseUrl = "https://rickandmortyapi.com/api/"
    
    enum HttpMethods {
        static let get = "GET"
    }
    
    // MARK: Characters
    func getAllCharacters(completion: @escaping (AllCharacters) -> Void){
        let characterURl = baseUrl + Endpoint.allCharacters
        guard let url = URL(string: characterURl) else {
            return
        }
        
        var urlRequest = URLRequest( url: url)
        urlRequest.httpMethod = HttpMethods.get
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let allCharacters = try? DataDecoder().decode(AllCharacters.self ,
                                                                    from: data) else {
                    return
                }
                
                completion(allCharacters)
            }
        }.resume()
    }
    
    func getCharacter( id: Int,
                       completion: @escaping (_ character: Character) -> ()){
        let idUrl = baseUrl + Endpoint.allCharacters + "\(id)"
        guard let url = URL(string: idUrl) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask( with: urlRequest) { data,response,error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let character = try? DataDecoder().decode(Character.self,
                                                                from: data) else {
                    return
                }
                
                completion(character)
            }
        }.resume()
    }
    
    func searchCharacters(name: String,
                          completion: @escaping (_ allCharacters: AllCharacters) -> ()) {
        let searchUrl = baseUrl + Endpoint.name + "\(name)"
        guard let url = URL(string: searchUrl) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let character = try? DataDecoder().decode(AllCharacters.self,
                                                                from: data) else {
                    return
                }
                
                completion(character)
            }
        }.resume()
    }
    
    // MARK: Episodes
    func getAllEpisodes(
        completion: @escaping (_ episodes: AllEpisodes) -> ()){
        let allEpisodesUrl = baseUrl + Endpoint.allEpisodes
        guard let url = URL(string: allEpisodesUrl) else {
            return
        }
            
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        URLSession.shared.dataTask(with: urlRequest) {data,response,error in
            DispatchQueue.main.async {
                guard let data,(response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let character = try? DataDecoder().decode(AllEpisodes.self,
                                                                from: data) else {
                    return
                }
                
                completion(character )
            }
        }.resume()
    }
    
    func getEpisode(url: String,
                    completion: @escaping (_ episode: Episode) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url )
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) { data,response,error in
            DispatchQueue.main.async {
                guard let data,(response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let episodes = try? DataDecoder().decode(Episode.self,
                                                               from: data) else {
                    return
                }
                
                completion(episodes)
            }
        }.resume()
    }
    
    func getArrayEpisodes(season: String,
                          completion: @escaping(_ episodes: Episodes) -> ()) {
        let seasonsUrl = baseUrl + Endpoint.allEpisodes + "\(season)"
        guard let url = URL(string: seasonsUrl) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let episodes = try? DataDecoder().decode(Episodes.self,
                                                               from: data ) else {
                    return
                }
                
                completion(episodes)
            }
        }.resume()
    }
    
    // MARK: Locations
    func getAllLocations(completion: @escaping(_ location: AllLocations) -> ()) {
        let locationsUrl = baseUrl + Endpoint.allLocations
        guard let url = URL(string: locationsUrl) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let locations = try? DataDecoder().decode(AllLocations.self,
                                                                from: data) else {
                    return
                }
                
                completion(locations)
            }
        }.resume()
    }
    
    // MARK: Pages
    func pages(url: String,
               completion: @escaping (_ allCharacters: AllCharacters) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        URLSession.shared.dataTask(with: urlRequest ) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let allCharacters = try? DataDecoder().decode(AllCharacters.self ,
                                                                    from: data) else {
                    return
                }
                
                completion( allCharacters )
            }
        }.resume()
    }
    
    func pagesLocation(url: String,
                       completion: @escaping (_ allLocations: AllLocations) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let allLocations = try? DataDecoder().decode(AllLocations.self ,
                                                                   from: data) else {
                    return
                }
                
                completion(allLocations)
            }
        }.resume()
    }
    
    func getCharacterUrl(url: String,
                         completion: @escaping (_ character: Character) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let character = try? DataDecoder().decode(Character.self,
                                                                from: data) else {
                    return
                }
                
                completion(character)
            }
        }.resume()
    }
    
    func getLocationUrl(url: String,
                        completion: @escaping (_ location: Location) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let location = try? DataDecoder().decode(Location.self,
                                                               from: data) else {
                    return
                }
                
                completion(location)
            }
        }.resume()
    }
    
    func getAllLocationsUrl( url: String,
                             completion: @escaping (_ locations: AllLocations) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.get
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let data,
                      (response as? HTTPURLResponse)?.statusCode == self.cstatusOk else {
                    return
                }
                
                guard error == nil else {
                    return
                }
                
                guard let locations = try? DataDecoder().decode(AllLocations.self,
                                                                from: data) else {
                    return
                }
                
                completion(locations)
            }
        }.resume()
    }
}

