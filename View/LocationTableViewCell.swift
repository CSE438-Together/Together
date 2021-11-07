//
//  LocationTableViewCell.swift
//  Together
//
//  Created by lcx on 2021/11/7.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    static let identifier = "LocationCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
