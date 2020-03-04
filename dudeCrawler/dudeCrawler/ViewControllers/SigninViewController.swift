//
//  SigninViewController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
    case noEncode
    case badResponse
}

class SigninViewController: UIViewController {

    @IBOutlet weak var optionsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var signInController: SignInController?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func uiSetup() {
        if optionsSegmentedControl.selectedSegmentIndex == 0 {
            password2TextField.isHidden = false
            confirmPasswordLabel.isHidden = false
            submitButton.setTitle("Register", for: .normal)
        } else {
            password2TextField.isHidden = true
            confirmPasswordLabel.isHidden = true
            submitButton.setTitle("Login", for: .normal)
        }
    }
    
    private func register() {
        guard let signInController = signInController,
            let username = usernameTextField.text,
            let password = password1TextField.text,
            let password2 = password2TextField.text else { return }
        let userToRegister = RegistrationInfo(username: username, password1: password, password2: password2)
        signInController.register(with: userToRegister) { error in
            if let error = error {
                NSLog("Error registering at SignInViewController:\(error)")
            }
            
            DispatchQueue.main.async {
                let user = User(username: username, password: password)
                self.signInController?.signIn(with: user, completion: { (token, error) in
                    if let error = error {
                        NSLog("Error signing in at registration:\(error)")
                    }
                })
            }
        }
    }
    
    func signIn() {
        guard let signInController = signInController,
            let username = usernameTextField.text,
            let password = password1TextField.text else { return }
        
        let userToSignIn = User(username: username, password: password)
        signInWith(user: userToSignIn) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                NSLog("Error logging in with \(result)")
            }
        }
        
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
                self.token = result["key"]
                if let token = self.token {
                    KeychainWrapper.standard.set(token, forKey: "token")
                    completion(.success(token))
                }
            } catch {
                NSLog("error decoding key:\(error)")
            }
        }.resume()
    }

    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if optionsSegmentedControl.selectedSegmentIndex == 0 {
            register()
        } else {
            signIn()
        }
    }
    
    @IBAction func optionControlValueChanged(_ sender: UISegmentedControl) {
        uiSetup()
    }
}
