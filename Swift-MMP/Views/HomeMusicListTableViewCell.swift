//
//  HomeMusicListTableViewCell.swift
//  Swift-MMP
//
//  Created by 吕文翰 on 2017/9/12.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

class HomeMusicListTableViewCell: UITableViewCell {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
