//
//  GameController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/4/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

class GameController {
    
    let accessKey = KeychainWrapper.standard.string(forKey: "accessKey")
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var enviornment: Enviornment?
    
    func startGameWith(token: String, completion: @escaping (Result<Enviornment, NetworkError>) -> Void) {
        let url = Settings.shared.baseURL.appendingPathComponent("api/adv/move/")
        let authString = "Token \(token)"
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        request.setValue("appication/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response.statusCode)
                completion(.failure(.badResponse))
                return
            }
            
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do{
                let result = try self.decoder.decode(Enviornment.self, from: data)
                self.enviornment = result
                print("\(self.enviornment!.title)")
                if let env = self.enviornment {
                    completion(.success(env))
                }
            } catch {
                
            }
        }.resume()
    }
    
    func move(direction: String, token: String, completion: @escaping (Result<Enviornment, NetworkError>) -> Void) {
        let url = Settings.shared.baseURL.appendingPathComponent("api/adv/init/")
        let authString = "Token \(token)"
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(authString, forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response.statusCode)
                completion(.failure(.badResponse))
                return
            }
            
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do{
                let result = try self.decoder.decode(Enviornment.self, from: data)
                self.enviornment = result
                print("\(self.enviornment!.title)")
                if let env = self.enviornment {
                    completion(.success(env))
                }
            } catch {
                
            }
        }.resume()
    }
}
