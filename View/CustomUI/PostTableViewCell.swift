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
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = contentView.bounds
        gradientlayer.colors = [UIColor.white.cgColor, UIColor(named: "bgLightBlue")!.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        contentView.layer.insertSublayer(gradientlayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = UIImage(systemName: "person")
    }    
}
