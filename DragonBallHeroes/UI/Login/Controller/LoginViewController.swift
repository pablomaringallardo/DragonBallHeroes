//
//  LoginViewController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 22/9/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            
            let alertController = UIAlertController(
                title: "Error",
                message: "Debes introducir un correo electrónico.",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default
            )
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
            return
        }
        
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            
            let alertController = UIAlertController(
                title: "Error",
                message: "No has introducido la contraseña.",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default
            )
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            
            return
        }
        
        NetworkManager.shared.login(email: email, password: password) { token, error in
            if let token = token {
                
                LocalDataManager.shared.saveToken(token: token)
                
                print("Login correcto: \(token)")
                
                DispatchQueue.main.async {
                    
                    UIApplication
                        .shared
                        .connectedScenes
                        .compactMap{
                            ($0 as? UIWindowScene)?.keyWindow
                        }
                        .first?
                        .rootViewController = HomeTabBarController()
                }
            } else {
                
                DispatchQueue.main.async {
                    
                    let loginAlertController = UIAlertController(
                        title: "Error",
                        message: "Email o contraseña incorrectos.",
                        preferredStyle: .alert
                    )

                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default
                    )

                    loginAlertController.addAction(okAction)
                    
                    self.present(loginAlertController, animated: true)
                }
            }
        }
    }
}
