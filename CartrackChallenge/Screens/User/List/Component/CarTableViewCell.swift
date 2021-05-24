//
//  CarTableViewCell.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import UIKit

final class CarTableViewCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = ""
    }
    
    func configure(for car: Car) {
        usernameLabel.text = car.username
    }
}
