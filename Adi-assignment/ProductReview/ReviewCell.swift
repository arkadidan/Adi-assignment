//
//  ReviewCell.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

final class ReviewCell: UITableViewCell {

    func configure(review: Review) {
        self.textLabel?.text = review.text
    }
}
