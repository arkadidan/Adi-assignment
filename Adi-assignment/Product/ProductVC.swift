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

    @IBOutlet private weak var reviewsLabel: UILabel!
    @IBOutlet private weak var reviewsTableView: UITableView!

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

        self.reviewsTableView.dataSource = self
        let nib = UINib(nibName: "ReviewCell", bundle: nil)
        self.reviewsTableView.register(nib, forCellReuseIdentifier: ReviewCell.identifier)

        self.viewModel.loadReviews { [weak self] in
            self?.reloadReviews()
        }
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
                self?.viewModel.addReview(text: text, completion: {
                    self?.reloadReviews()
                })
            }
        }
        alert.addAction(submit)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)

        textView.becomeFirstResponder()

        present(alert, animated: true, completion: nil)
    }

    private func reloadReviews() {
        self.reviewsLabel.isHidden = self.viewModel.numberOfReviews() == 0
        self.reviewsTableView.reloadData()
    }
}

extension ProductVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfReviews()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier) as! ReviewCell
        cell.configure(review: self.viewModel.review(indexPath: indexPath))
        return cell
    }
}
