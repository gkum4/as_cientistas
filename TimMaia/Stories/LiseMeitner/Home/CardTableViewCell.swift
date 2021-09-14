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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
