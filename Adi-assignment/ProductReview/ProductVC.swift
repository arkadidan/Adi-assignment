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

        self.title = self.viewModel.productName()

        configureViews()
        setBindings()

        reloadReviews()
    }

    private func setBindings() {
        self.viewModel.onError = { [weak self] error in
            self?.presentErrorAlert(error: error)
        }
        self.viewModel.loadReviews { [weak self] in
            self?.reloadReviews()
        }
    }

    private func configureViews() {
        let addReviewBarItem = UIBarButtonItem(title: "Add review", style: .plain, target: self, action: #selector(onAddReview))
        self.navigationItem.rightBarButtonItem = addReviewBarItem

        if let url = self.viewModel.productImageUrl() {
            self.productImageView.loadImage(url: url)
        }
        self.productNameLabel.text = self.viewModel.productName()
        self.productPriceLabel.text = self.viewModel.productPrice()
        self.productDescLabel.text = self.viewModel.productDesc()

        self.reviewsTableView.dataSource = self
        let nib = UINib(nibName: "ReviewCell", bundle: nil)
        self.reviewsTableView.register(nib, forCellReuseIdentifier: ReviewCell.identifier)
    }

    @objc private func onAddReview() {

        let submitBlock: (String?) -> Void = { [weak self] text in
            guard let text = text else { return }
            self?.viewModel.addReview(text: text, completion: {
                self?.reloadReviews()
            })
        }

        let (alert, textView) = self.addReviewAlertController(submitBlock: submitBlock)

        present(alert, animated: true, completion: {
            textView.becomeFirstResponder()
        })
    }

    private func addReviewAlertController(submitBlock: @escaping (String?) -> Void) -> (UIAlertController, UITextView) {
        let alert = UIAlertController(title: "Add Review", message: nil, preferredStyle: .alert)
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let controller = UIViewController()

        textView.frame = controller.view.frame
        controller.view.addSubview(textView)

        alert.setValue(controller, forKey: "contentViewController")
        alert.view.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            submitBlock(textView.text)
        }
        alert.addAction(submit)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)

        return (alert, textView)
    }

    private func reloadReviews() {
        self.reviewsLabel.text = self.viewModel.numberOfReviews() == 0 ? "No reviews" : "Reviews"
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
