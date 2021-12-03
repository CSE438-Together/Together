//
//  PostDetailTableViewDeleteCell.swift
//  Together
//
//  Created by Bingxin Liu on 12/2/21.
//

import UIKit

class PostDetailTableViewDeleteCell: UITableViewCell {
    
    @IBOutlet var deleteButton : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewDeleteCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewDeleteCell", bundle: nil)
    }
    
    public func configure() {
        
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        print("delete")
    }
    
    
}
