//
//  PostDetailTableViewTimeCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewTimeCell: UITableViewCell {
    
    @IBOutlet var departureTime : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewTimeCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewTimeCell", bundle: nil)
    }
    
    public func configure( with time : String ) {
        self.departureTime.text = "Departure Time: " + time
    }
    
}
