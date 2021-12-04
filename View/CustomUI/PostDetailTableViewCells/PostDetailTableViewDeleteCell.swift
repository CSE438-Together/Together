//
//  PostDetailTableViewDeleteCell.swift
//  Together
//
//  Created by Bingxin Liu on 12/2/21.
//

import UIKit

class PostDetailTableViewDeleteCell: UITableViewCell {
    
    @IBOutlet var deleteLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewDeleteCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewDeleteCell", bundle: nil)
    }
    
    public func configure(with frameWidth : CGFloat, with frameHeight : CGFloat) {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.deleteLabel.layer.cornerRadius = 10
    }
    
}
