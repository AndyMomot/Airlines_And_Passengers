//
//  PassengerCell.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 15.9.22.
//

import UIKit

struct PassengerCellModel {
    let name: String
    let trips: Int
    let airline: String
    let paginationNumber: Int
    
    init(name: String?, trips: Int?, airline: String?, paginationNumber: Int) {
        self.name = name ?? ""
        self.trips = trips ?? 0
        self.airline = airline ?? ""
        self.paginationNumber = paginationNumber
    }
}

class PassengerCell: UITableViewCell, ReusableView, NibLoadableView {
    private let customBackgroundColor = UIColor(named: "Black")
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tripsLabel: UILabel!
    @IBOutlet private weak var airlineNameLabel: UILabel!
    @IBOutlet private weak var paginationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }    
}

extension PassengerCell {
    
    func config(viewModel: PassengerCellModel) {
        nameLabel.text = viewModel.name
        tripsLabel.text = String(viewModel.trips)
        airlineNameLabel.text = viewModel.airline
        paginationLabel.text = String(viewModel.paginationNumber)
    }
    
    func hidePaginationLabel(is argument: Bool) {
        paginationLabel.isHidden = argument
    }
    
    func configUI() {
        containerView.backgroundColor = backgroundColor
        containerView.layer.shadowColor = UIColor.white.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.7
    }
}
