//
//  AirlineCell.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 15.9.22.
//

import UIKit

struct AirlineCellModel {
    let name: String
    let slogan: String
    var image: UIImage
    
    init(name: String?, slogan: String?, imageURL: String?) {
        self.name = name ?? ""
        self.slogan = slogan ?? ""
        self.image =  UIImage(named: "logo.img")!
        
        let urlString = imageURL ?? ""
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.image = UIImage(data: data) ?? UIImage(named: "logo.img")!
            }
        } else {
            print("Invalid url for airline logo")
        }
    }
}

class AirlineCell: UITableViewCell, ReusableView, NibLoadableView {
    private let customBackgroundColor = UIColor(named: "Black")
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sloganLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    override func prepareForReuse() {
        logoImageView.image = UIImage(named: "logo.img")!
    }
    
    func config(viewModel: AirlineCellModel) {
        nameLabel.text = viewModel.name
        sloganLabel.text = viewModel.slogan
        logoImageView.image = viewModel.image
    }
}

private extension AirlineCell {
    func configUI() {
        containerView.backgroundColor = customBackgroundColor
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2
        containerView.layer.shadowColor = UIColor.white.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.7
    }
}
