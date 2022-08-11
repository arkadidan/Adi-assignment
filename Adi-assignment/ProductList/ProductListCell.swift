//
//  ProductListCell.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

final class ProductListCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var prodImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.descLabel.numberOfLines = 0
    }

    override func prepareForReuse() {
        self.nameLabel.text = nil
        self.priceLabel.text = nil
        self.descLabel.text = nil
        self.prodImageView.image = nil
    }

    func configure(product: Product) {
        self.nameLabel.text = product.name
        self.priceLabel.text = product.currency + "\(product.price)"
        self.descLabel.text = product.description
        if let url = URL(string: product.imgUrl) {
            self.prodImageView.loadImage(url: url)
        }
    }
}

extension UIImageView {

    func loadImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
