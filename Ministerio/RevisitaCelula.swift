//
//  RevisitaCelula.swift
//  Ministerio
//
//  Created by DEIVID LOUREIRO on 26/12/16.
//  Copyright © 2016 DEIVID LOUREIRO. All rights reserved.
//

import UIKit

class RevisitaCelula: UITableViewCell {

    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblTerritorioEndereco: UILabel!
    @IBOutlet weak var lblProximaVisita: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
