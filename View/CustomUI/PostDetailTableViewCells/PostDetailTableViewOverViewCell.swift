//
//  PostDetailTableViewOverViewCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewOverViewCell: UITableViewCell {
    
    @IBOutlet var titleView : UILabel!
    @IBOutlet var descriptionView : UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewOverViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewOverViewCell", bundle: nil)
    }
    
    public func configure( with title : String, with description : String ) {
        self.titleView.text = title
        self.descriptionView.text = description
        self.descriptionView.isEditable = false
    }
    
}
