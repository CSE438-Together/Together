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
    @IBOutlet var memberGenderView : UILabel!
    @IBOutlet var memberNameView : UILabel!
    @IBOutlet var shadowView : UIView!
    @IBOutlet var memberGenderImageView : UIImageView!

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
    
    public func configure( with memberId : String, with memberAvatar : UIImage, with memberNickName : String, with memberGender : String) {
        self.memberView.text = "Name: " + memberNickName
        self.memberAvatarView.image = memberAvatar
        self.memberAvatarView.layer.cornerRadius = 15
        
        self.memberGenderView.text = "Gender: " + memberGender
        switch memberGender {
        case "Male":
            self.memberGenderImageView.image = UIImage(named: "male")
        case "Female":
            self.memberGenderImageView.image = UIImage(named: "female")
        default:
            self.memberGenderImageView.image = UIImage(named: "allGender")
        }
        
        
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
