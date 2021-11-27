//
//  MembersTableViewCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/20/21.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet var memberView : UILabel!

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
    
    public func configure( with memberId : String) {
        self.memberView.text = memberId
        
    }
    
}
