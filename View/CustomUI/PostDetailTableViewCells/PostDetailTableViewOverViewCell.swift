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
    @IBOutlet var shadowView : UIView!
    @IBOutlet var descriptionShadowView: UIView!

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
    
    static let identifier = "PostDetailTableViewOverViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewOverViewCell", bundle: nil)
    }
    
    public func configure( with title : String, with description : String ) {
        self.titleView.text = title
        self.descriptionView.text = description
        self.descriptionView.isEditable = false
        self.descriptionView.backgroundColor = .none
        
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        
        self.shadowView.layer.zPosition = -2
        
        self.shadowView.backgroundColor = UIColor(named: "bgGreen")
        
        self.descriptionShadowView.layer.shadowColor = UIColor.gray.cgColor
        self.descriptionShadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.descriptionShadowView.layer.shadowOpacity = 0.8
        self.descriptionShadowView.layer.masksToBounds = false
        self.descriptionShadowView.layer.cornerRadius = 10
        
        self.descriptionShadowView.layer.zPosition = -1
        
        self.descriptionShadowView.backgroundColor = UIColor(named: "bgDarkBlue")
        
    }
    
}
