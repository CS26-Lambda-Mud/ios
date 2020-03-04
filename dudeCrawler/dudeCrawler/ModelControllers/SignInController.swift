//
//  SignInController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum AccessToken: String {
    case accessToken
}

class SignInController {
    
    var key: String? 
    
    func register(with registrationInfo: RegistrationInfo, completion: @escaping (Error?) -> Void) {
        let url = Settings.shared.baseURL.appendingPathComponent("api").appendingPathComponent("registration/")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(registrationInfo)
        } catch {
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 && response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func signInWith(user: User, completion: @escaping (Result<String, NetworkError>) -> Void) {
          let url = Settings.shared.baseURL.appendingPathComponent("api/login/")
          var request = URLRequest(url:url)
          request.httpMethod = HTTPMethod.post.rawValue
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
          let encoder = JSONEncoder()
          do {
              request.httpBody = try encoder.encode(user)
          } catch {
              NSLog("Error encoding:\(error)")
              completion(.failure(.noEncode))
              return
          }
          
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
              
              let decoder = JSONDecoder()
              do{
                  let result = try decoder.decode(Dictionary<String, String>.self, from: data)
                  self.key = result["key"]
                  if let key = self.key {
                      KeychainWrapper.standard.set(key, forKey: "accessKey")
                      completion(.success(key))
                  }
              } catch {
                  NSLog("error decoding key:\(error)")
              }
          }.resume()
      }
}
