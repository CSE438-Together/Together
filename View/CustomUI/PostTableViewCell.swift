//
//  PostTableViewCell.swift
//  Together
//
//  Created by Moran Xu on 10/29/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var when: UILabel!
    @IBOutlet weak var numOfMembers: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userAvatar.layer.cornerRadius = userAvatar.frame.width/2
        shadowView.layer.shadowColor = UIColor.gray.cgColor;
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 3
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 10
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9850923419, blue: 0.8796316385, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
