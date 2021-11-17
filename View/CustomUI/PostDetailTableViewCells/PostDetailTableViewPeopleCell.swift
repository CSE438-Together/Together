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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
    
}
