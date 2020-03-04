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
    
    var token: String? = KeychainWrapper.standard.string(forKey: AccessToken.accessToken.rawValue)
    
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
    
    func signIn(with user: User, completion: @escaping (String?, Error?) -> Void) {
        let url = Settings.shared.baseURL.appendingPathComponent("api").appendingPathComponent("login/")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(user)
            print(request.httpBody)
            print(request.httpBody!)
        } catch {
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(nil, NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                NSLog("error getting token at sign in:\(error)")
                return
            }
            do{
                let jsonDecoder = JSONDecoder()
                self.token = try jsonDecoder.decode(String.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let accessToken = parseJSON["key"] as? String
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: AccessToken.accessToken.rawValue)
                    print("The access token save result: \(saveAccessToken)")
                    if (accessToken?.isEmpty)! {
                        NSLog("Error parsking token:\(error)")
                    }
                }
            } catch {
                NSLog("error parsing token:\(error)")
                return
            }
            completion(self.token,nil)
        }.resume()
    }
}
