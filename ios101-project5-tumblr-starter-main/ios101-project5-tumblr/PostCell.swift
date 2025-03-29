//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Richard M on 3/28/25.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
//    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
