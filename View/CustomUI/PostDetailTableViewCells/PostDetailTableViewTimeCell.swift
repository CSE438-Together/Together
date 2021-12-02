//
//  PostDetailTableViewTimeCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewTimeCell: UITableViewCell {
    
    @IBOutlet var departureTime : UILabel!
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
    
    static let identifier = "PostDetailTableViewTimeCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewTimeCell", bundle: nil)
    }
    
    public func configure( with time : String ) {
        self.departureTime.text = time
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        
        self.shadowView.layer.zPosition = -1
        
        self.shadowView.backgroundColor = UIColor(named: "bgGreen")
    }
    
}
