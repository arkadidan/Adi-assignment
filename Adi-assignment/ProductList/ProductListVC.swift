//
//  ProductListVC.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

final class ProductListVC: UIViewController {

    var viewModel: ProductListVM!
    var onOpenProduct: ((Product) -> Void)?

    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Products"

        configureViews()
        setBindings()

        self.loadData()
    }

    private func configureViews() {
        self.searchField.placeholder = "Search"
        self.searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let cellNib = UINib(nibName: "ProductListCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: ProductListCell.identifier)
    }

    private func setBindings() {
        self.viewModel.onError = { [weak self] error in
            let message = error.localizedDescription
            self?.presentErrorAlert(message: message)
        }
    }

    private func loadData() {
        self.showSpinner(true)
        self.viewModel.loadData { [weak self] in
            self?.showSpinner(false)
            self?.tableView.reloadData()
        }
    }

    private var spinner: UIActivityIndicatorView?
    func showSpinner(_ show: Bool) {
        if show {
            let spinner = UIActivityIndicatorView(style: .large)
            self.view.addSubview(spinner)
            spinner.center = self.view.center
            spinner.startAnimating()
            self.spinner = spinner
        } else {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }

    @objc private func textFieldDidChange() {
        self.viewModel.searchString = self.searchField.text
        self.tableView.reloadData()
    }
}

extension ProductListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as! ProductListCell
        cell.configure(product: self.viewModel.item(indexPath: indexPath))
        return cell
    }

}

extension ProductListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = self.viewModel.item(indexPath: indexPath)
        self.onOpenProduct?(product)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
