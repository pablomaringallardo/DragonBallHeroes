//
//  TransformationsViewController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 24/9/23.
//

import UIKit

class TransformationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Variables y constantes
    
    var transformations: [Transformation] = []
    var heroe: Heroe!
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Transformaciones de \(heroe.name)"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customCell")
        
    }
    
    // Crea celdas segun el numero de transformaciones que le llegue
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transformations.count
    }
    
    // Asigna cada dato en su campo
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
        let transformation = transformations[indexPath.row]
        
        cell.titleLabel.text = transformation.name
        cell.iconImageView.setImage(url: transformation.photo)
        cell.descriptionLabel.text = transformation.description
        
        return cell
        
        
    }
    
    // Le da una altura a todas las celdas
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // Controla en que celda a tocado el usuario
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transformation = transformations[indexPath.row]
        let detailView = DetailTransformationViewController()
        detailView.transformation = transformation
        navigationController?.pushViewController(detailView, animated: true)
    }
}
