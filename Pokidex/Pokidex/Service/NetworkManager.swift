//
//  NetworkManager.swift
//  Pokidex
//
//  Created by Consultant on 5/4/22.
//

import Foundation

class NetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension NetworkManager {
    
    func fetchPokemon(offset: Int, completion: @escaping (Result<PageResult, Error>) -> Void) {
                        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30&offset=\(offset)") else {
            print("error with url")
            return
            }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            do {
                let pageResult = try JSONDecoder().decode(PageResult.self, from: data)
                completion(.success(pageResult))
            } catch {
                completion(.failure(NetworkError.decodeError("\(error)")))
            }
            
        }.resume()
    }
    
    func fetchPokemonInfo(urlPath: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard let url = URL(string: "\(urlPath)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            do {
                let pageResult = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pageResult))
            } catch {
                completion(.failure(NetworkError.decodeError("\(error)")))
            }
            
        }.resume()
    }
    
    func fetchImageData(imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: "\(imagePath)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badServerResponse(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }

            completion(.success(data))
            
        }.resume()
        
    }
}
