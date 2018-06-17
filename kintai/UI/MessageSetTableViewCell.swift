//
//  messageSetTableViewCell.swift
//  kintai
//
//  Created by KAMAKURAKAZUHIRO on 2018/05/30.
//  Copyright © 2018年 KAMAKURAKAZUHIRO. All rights reserved.
//

import UIKit

class MessageSetTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    static let cellHeight: CGFloat = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(title: String) {
       titleLabel!.text    = title
    }
}
