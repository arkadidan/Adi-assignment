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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.onError = { [weak self] error in
            let message = error.localizedDescription
            self?.presentErrorAlert(message: message)
        }
    }
}

extension UIViewController {

    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
    }

    static var storyboardId: String {
        return String(describing: self)
    }
 }

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: type.storyboardId) as! T
    }
}
