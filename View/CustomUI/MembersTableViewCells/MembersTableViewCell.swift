//
//  MembersTableViewCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/20/21.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet var memberView : UILabel!
    @IBOutlet var memberAvatarView : UIImageView!
    @IBOutlet var shadowView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MembersTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MembersTableViewCell", bundle: nil)
    }
    
    public func configure( with memberId : String, with memberAvatar : UIImage) {
        self.memberView.text = memberId
        self.memberAvatarView.image = memberAvatar
        self.memberAvatarView.layer.cornerRadius = 15
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 15
        
        self.shadowView.layer.zPosition = -1
        
    }
    
}
