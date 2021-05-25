//
//  ContactoTableViewCell.swift
//  ContactosCoreData
//
//  Created by Jorge Luis Baltazar Perez on 18/05/21.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var contactoImagen: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.masksToBounds = false

                backView.layer.cornerRadius = 9

                backView.layer.shadowColor = UIColor.gray.cgColor

                backView.layer.shadowOpacity = 0.5

                backView.layer.shadowOffset = .zero

                backView.layer.shadowRadius = 5 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
