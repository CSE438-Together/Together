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
    
    public func configure( with joinedPeopleNum : Int , with maxPeopleNum : Int) {
        self.statusView.text = "\(joinedPeopleNum)/\(maxPeopleNum)"
        self.progressView.progress = Float(joinedPeopleNum)/Float(maxPeopleNum)
        
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
