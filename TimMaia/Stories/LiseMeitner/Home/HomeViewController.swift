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
  
  private func loadScene(vc: UIViewController) {
      vc.modalPresentationStyle = .fullScreen
      vc.modalTransitionStyle = .crossDissolve

      self.present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let image = images [indexPath.row]
        
        let cell = tableCards.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        
        cell.thumbnails.image = image
       
      cell.selectionStyle = .none
      
      if indexPath.row != 0 {
        cell.contentView.alpha = 0.4
      }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (indexPath.row)
        
        switch indexPath.row {
        case 0:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
//            self.present(vc, animated: true)
          loadScene(vc: LiseMeitnerSceneViewController())
        case 1:
            print ("vai para a tela da história 2") //substituir o print para a mudança de tela
        case 2:
            print ("vai para a tela da história 3")
        case 3:
            print ("vai para a tela da história 4")
        case 4:
            print ("vai para a tela da história 5")
        default:
            print ("card inválido")
            
        }
        
    }
    
}
