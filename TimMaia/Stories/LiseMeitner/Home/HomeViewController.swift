//
//  HomeViewViewController.swift
//  TimMaia
//
//  Created by Frederico Westphalen Mendes Machado on 13/09/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableCards: UITableView!
    
    let images : [UIImage] = [#imageLiteral(resourceName: "Thumbnail Lise 370x150"),#imageLiteral(resourceName: "Thumbnail Rosalind 370x150"),#imageLiteral(resourceName: "Thumbnail Annie 370x150"),#imageLiteral(resourceName: "Thumbnail Katherine 370x150"),#imageLiteral(resourceName: "Thumbnail Lilian 370x150")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableCards.backgroundColor = .white
        
        tableCards.delegate = self
        tableCards.dataSource = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let image = images [indexPath.row]
        
        let cell = tableCards.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        
        cell.thumbnails.image = image
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (indexPath.row)
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
            self.present(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "segundaHistoria")
            self.present(vc, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "terceiraHistoria")
            self.present(vc, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "quartaHistoria")
            self.present(vc, animated: true)
        case 4:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "quintaHistoria")
            self.present(vc, animated: true)
        default:
            print ("historia inexistente")

        }
        
    }
    
}
