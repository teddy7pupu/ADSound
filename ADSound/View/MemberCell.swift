//
//  MemberCell.swift
//  ADSound
//
//  Created by msp310 on 2018/3/23.
//  Copyright © 2018年 msp310. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var mailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func layoutCell(_ mail: String?){
        mailLbl.text = mail
    }
}
