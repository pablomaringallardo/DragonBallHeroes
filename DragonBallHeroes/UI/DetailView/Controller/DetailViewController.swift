//
//  DetailViewController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 24/9/23.
//

import UIKit

class DetailViewController: UIViewController {

    var transformations: [Transformation] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleNameView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var bottonView: UIButton!
    var heroe: Heroe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNameView.text = heroe.name
        imageView.setImage(url: heroe.photo)
        descriptionView.text = heroe.description
        bottonView.alpha = 0
        
        let token = LocalDataManager.shared.getToken()
        
        getTransformation(token: token, id: heroe.id)
        
        
    }
    
    
    func getTransformation(token: String, id: String) {
        NetworkManager.shared.fetchTransformations(token: token, id: id) { allTransformations, error in
            if let allTransformations = allTransformations {
                self.transformations = allTransformations
                if !self.transformations.isEmpty {
                    DispatchQueue.main.async {
                        self.bottonView.alpha = 1
                    }
                }
            } else {
                print("Error fetching transformations: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    
    @IBAction func transformationBottonView(_ sender: Any) {
        let transformationView = TransformationsViewController()
        transformationView.transformations = self.transformations
        transformationView.heroe = self.heroe
        navigationController?.pushViewController(transformationView, animated: true)
    }
    
}
