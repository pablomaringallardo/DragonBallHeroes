//
//  ListHeroesTableViewController.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 22/9/23.
//

import UIKit

class ListHeroesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var heroes: [Heroe] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegados
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Dragon Ball Super"
        
        // Registro de celda custom
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
    
    
        // Obtengo el token
        let token = LocalDataManager.shared.getToken()
        getHeroesList(token: token)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(logOut)
        )
    }
    
    // MARK: - Cerrar sesión
    
    @objc func logOut() {
        
        let alertController = UIAlertController(
            title: "Cerrar sesión",
            message: "¿Estás seguro de que quieres cerrar sesión?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            LocalDataManager.shared.deleteToken()
            self.view.window?.rootViewController = LoginViewController()
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancelar",
            style: .cancel
        )
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Call Api
    
    func getHeroesList(token: String) {
        NetworkManager.shared.fetchHeroes(token: token) { allHeros, error in
            if let allHeros = allHeros {
                self.heroes = allHeros
                
                // Refrescamos el tableView para los nuevos datos que vienen de la api
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error fetching heroes: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    // MARK: - Delegados
    
    // Creamos celdas dependiendo de la cantidad de heroes que lleguen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroes.count
    }
    
    // Asignamos cada dato en su campo
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        let heroe = heroes[indexPath.row]
        
        cell.titleLabel.text = heroe.name
        cell.descriptionLabel.text = heroe.description
        cell.iconImageView.setImage(url: heroe.photo)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroe = heroes[indexPath.row]
        let detailView = DetailViewController()
        detailView.heroe = heroe
        navigationController?.pushViewController(detailView, animated: true)
    }
}
