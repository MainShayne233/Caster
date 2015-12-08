//
//  ShowTableViewCell.swift
//  Caster
//
//  Created by Josh Koch on 12/4/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

import UIKit

/*protocol ShowCellProtocol {
    var title: String { get }
    var authors: String { get }
    var showImage: UIImage { get }
    
    var titleColor: UIColor { get }
    var authorColor: UIColor { get }
} */


class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    
    //private var delegate: ShowCellProtocol?
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
