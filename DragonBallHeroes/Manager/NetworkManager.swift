//
//  NetworkManager.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 22/9/23.
//

import Foundation

let baseUrl = "https://dragonball.keepcoding.education"

enum Endpoint: String {
    case login = "/api/auth/login"
    case listHeroes = "/api/heros/all"
    case transformation = "/api/heros/tranformations"
}

enum NetworkError: Error {
    case malformedUrl
    case noData
    case statusCode(code: Int?)
    case decodingFailed
}

enum HttpMethods: String {
    case post = "POST"
}



final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func login(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(Endpoint.login.rawValue)") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        // Convertir email y password a base64
        
        let loginString = "\(email):\(password)"
        let loginData: Data = loginString.data(using: .utf8)!
        let base64 = loginData.base64EncodedString()
        
        // Creamos la request
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(token, nil)
            
        }
        task.resume()
    }
    
    // MARK: - HeroesList
    
    func fetchHeroes(token: String?, completion: @escaping ([Heroe]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseUrl)\(Endpoint.listHeroes.rawValue)") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let heroes = try? JSONDecoder().decode([Heroe].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(heroes, nil)
        }
        
        task.resume()
        
    }
    
    func fetchTransformations(token: String?, id: String?, completion: @escaping ([Transformation]?, Error?) -> Void){
        guard let url = URL(string: "\(baseUrl)\(Endpoint.transformation.rawValue)") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: id ?? "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            
            guard let transformations = try? JSONDecoder().decode([Transformation].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            
            completion(transformations, nil)
        }
        
        task.resume()
        
    }
}
