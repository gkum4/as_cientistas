//
//  MenuAboutViewController.swift
//  TimMaia
//
//  Created by Frederico Westphalen Mendes Machado on 16/09/21.
//

import UIKit
import SpriteKit

class MenuAboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableMenuAbout: UITableView!
    
    
    let textArray = ["Her Science Stories", "Women in science", "References", "Developers team", "Contact us"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableMenuAbout.dequeueReusableCell(withIdentifier: "LabelCellMenuAbout", for: indexPath) as! MenuAboutTableViewCell
        
        cell.LabelCellMenuAbout.text = textArray [indexPath.row]
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableMenuAbout.delegate = self
        tableMenuAbout.dataSource = self
    }
  
  private func loadScene() {
    let vc = ViewController()

    vc.modalPresentationStyle = .fullScreen

    self.present(vc, animated: true)
  }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
        case 0:
//            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
//            self.present(vc, animated: true)
            loadScene()
        case 1:
            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
            self.present(vc, animated: true)
        case 2:
            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
            self.present(vc, animated: true)
        case 3:
            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
            self.present(vc, animated: true)
        case 4:
            let vc = storyboard.instantiateViewController(withIdentifier: "primeiraHistoria")
            self.present(vc, animated: true)
        default:
            print ("Item inexistente")
            
        }
        
    }

}
