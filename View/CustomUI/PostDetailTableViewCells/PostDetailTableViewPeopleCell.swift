//
//  PostDetailTableViewPeopleCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewPeopleCell: UITableViewCell {
    
    @IBOutlet var statusView : UILabel!
    @IBOutlet var progressView : UIProgressView!
    @IBOutlet var creatorAvatarView : UIImageView!
    @IBOutlet var shadowView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewPeopleCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewPeopleCell", bundle: nil)
    }
    
    public func configure( with joinedPeopleNum : Int , with maxPeopleNum : Int, with creatorAvator : UIImage, with memberAvatarCache : [String: UIImage?], with members : [String?]?, with owner : String) {
        self.statusView.text = "\(joinedPeopleNum)/\(maxPeopleNum)"
        self.progressView.progress = Float(joinedPeopleNum)/Float(maxPeopleNum)
        self.creatorAvatarView.image = creatorAvator
        self.creatorAvatarView.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        
        self.shadowView.layer.zPosition = -1
        
        self.shadowView.backgroundColor = UIColor(named: "bgGreen")
        
        var membersLeadingPadding : CGFloat = 15.0
        
        guard let members = members else {return}
        for member in members {
            if member == nil {continue}
            if member! == owner {continue}
            let imageView = UIImageView(
                frame: CGRect(x: self.creatorAvatarView.frame.midX + membersLeadingPadding,
                              y: self.creatorAvatarView.frame.minY,
                              width: 20,
                              height: 20))
            if memberAvatarCache[member!] != nil {
                imageView.image = memberAvatarCache[member!]!
            } else {
                imageView.image = UIImage(named: "defaultPerson")
            }
            imageView.layer.cornerRadius = 10
            imageView.backgroundColor = .white
            self.contentView.addSubview(imageView)
            membersLeadingPadding += 5
            
            if membersLeadingPadding >= self.contentView.frame.width - 200 {break}
        }
    }
    
}
