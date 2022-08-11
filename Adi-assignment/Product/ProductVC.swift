//
//  ProductVC.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

final class ProductVC: UIViewController {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescLabel: UILabel!

    @IBOutlet private weak var reviewsTableView: UITableView!


    @IBOutlet private weak var addReviewButton: UIButton!

    var viewModel: ProductVM!

    override func viewDidLoad() {
        super.viewDidLoad()

        let addReviewBarItem = UIBarButtonItem(title: "Add review", style: .plain, target: self, action: #selector(onAddReview))
        self.navigationItem.rightBarButtonItem = addReviewBarItem

        self.title = self.viewModel.productName()
        if let url = self.viewModel.productImageUrl() {
            self.productImageView.loadImage(url: url)
        }
        self.productNameLabel.text = self.viewModel.productName()
        self.productPriceLabel.text = self.viewModel.productPrice()
        self.productDescLabel.text = self.viewModel.productDesc()
    }

    @objc private func onAddReview() {
        let alert = UIAlertController(title: "Add Review", message: nil, preferredStyle: .alert)
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let controller = UIViewController()

        textView.frame = controller.view.frame
        controller.view.addSubview(textView)

        alert.setValue(controller, forKey: "contentViewController")

        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: view.frame.height * 0.5)
        alert.view.addConstraint(height)

        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            if let text = textView.text {
                self?.viewModel.addReview(text: text)
            }
        }
        alert.addAction(submit)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)

        textView.becomeFirstResponder()

        present(alert, animated: true, completion: nil)
    }
}
