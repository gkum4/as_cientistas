//
//  IntroHistoriaViewController.swift
//  TimMaia
//
//  Created by Frederico Westphalen Mendes Machado on 15/09/21.
//

import UIKit

class IntroHistoriaViewController: UIViewController {

    
    @IBOutlet weak var labelIntroHistoria: UILabel!
    
    
    @IBOutlet weak var labelSinopseHistoria: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
 //       setupTextViewSinopse()
    }
    
  private func loadScene(vc: UIViewController) {
      vc.modalPresentationStyle = .fullScreen
      vc.modalTransitionStyle = .crossDissolve

      self.present(vc, animated: true)
    }
    
    func setupTextViewSinopse () {
        
        let alturaTextoSinopse = labelSinopseHistoria.frame.height
      
        let fontSize = alturaTextoSinopse * 0.093
        
        //Para ajustar o tamanho do texto, de acordo com o tamanho da view em cada device, usamos uma regra de três e chegamos ao número 0.093 em relação ao protótipo feito no iPhone 12.
        
        labelSinopseHistoria.font = UIFont (name: labelSinopseHistoria.font!.fontName, size: fontSize)
        
    }

  @IBAction func onStartPress(_ sender: Any) {
    loadScene(vc: LiseMeitnerSceneViewController())
  }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
