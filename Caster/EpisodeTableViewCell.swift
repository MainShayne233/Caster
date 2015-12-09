//
//  EpisodeTableViewCell.swift
//  Caster
//
//  Created by Josh Koch on 12/8/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var epTitleLabel: UILabel!
    @IBOutlet weak var epDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
