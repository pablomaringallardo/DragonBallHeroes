//
//  DetailTransformationViewController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 25/9/23.
//

import UIKit

class DetailTransformationViewController: UIViewController {

    var transformation: Transformation!
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
        imageView.setImage(url: transformation.photo)
        
    }

}
