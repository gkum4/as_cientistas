//
//  CardTableViewCell.swift
//  TimMaia
//
//  Created by Frederico Westphalen Mendes Machado on 14/09/21.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnails: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        thumbnails.layer.shadowColor = UIColor.red.cgColor
//        thumbnails.layer.shadowOpacity = 1
//        thumbnails.layer.shadowOffset = .zero
//        thumbnails.layer.shadowRadius = 30
//
//
//        self.clipsToBounds = false
//        thumbnails.clipsToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        
        
        
    }

}





