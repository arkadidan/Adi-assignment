//
//  ProductListVMTests.swift
//  Adi-assignmentTests
//
//  Created by arkadi.daniyelian on 12/08/2022.
//

import XCTest
@testable import Adi_assignment

class ProductListVMTests: XCTestCase {

//    private var mockSession: UrlSessionMock!
    private var httpService: MockHttpService!
    private var viewModel: ProductListVM!

    override func setUp() {
        super.setUp()

//        mockSession = UrlSessionMock()
        httpService = MockHttpService()
        viewModel = ProductListVM(httpService: httpService)
    }

    func testLoadData() {
        let exp = expectation(description: #function)

        let products: [Product] = try! JSONDecoder().decode([Product].self, from: prodListResponseData)
        httpService.response = products

        viewModel.loadData {
            XCTAssertEqual(self.viewModel.numberOfRows(), products.count)
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testError() {
        let exp = expectation(description: #function)

        httpService.error = "err"

        viewModel.onError = { _ in
            exp.fulfill()
        }

        viewModel.loadData {
            XCTFail("expected error")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}

extension String: Error {}

private class MockHttpService: HttpServicveProtocol {

    var response: [Product]!
    var error: Error!

    func sendRequest<T>(_ urlRequest: URLRequest) async throws -> T where T : Decodable {
        try! await Task.sleep(nanoseconds: UInt64(0.5e9))

        if let error = self.error {
            throw error
        }
        return response as! T
    }
}

private var prodListResponseData = """
[
  {
    "currency": "$",
    "price": 74,
    "id": "HI333",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c7099422ccc14e44b406abec00ba6c96_9366/NMD_R1_V2_Shoes_Black_FY6862_01_standard.jpg"
  },
  {
    "currency": "$",
    "price": 100,
    "id": "HI334",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/c93fa315d2f64775ac1fab96016f09d1_9366/Dame_6_Shoes_Black_FV8624_01_standard.jpg"
  },
  {
    "currency": "$",
    "price": 66,
    "id": "HI336",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/3eebc0498b1347e397f8ab94016140ba_9366/FS1496_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 67,
    "id": "HI337",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/f7b3df22026b42b8b539a9d300adb52b_9366/DZ9416_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 66,
    "id": "HI338",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_276,h_276,f_auto,q_auto:sensitive,fl_lossy/c089e9b31e01406bbee5abc9009a421e_9366/FV9996_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 43,
    "id": "HI339",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_276,h_276,f_auto,q_auto:sensitive,fl_lossy/da278c9c5e244068b32cac4d0125fedd_9366/FY2002_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 87,
    "id": "HI340",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_276,h_276,f_auto,q_auto:sensitive,fl_lossy/3e13d15c862749708801ac4d01257e1c_9366/FY0072_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 25,
    "id": "HI341",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_276,h_276,f_auto,q_auto:sensitive,fl_lossy/dd6788b5e79742c3bfbaac4e00f57272_9366/FY9386_00_plp_standard.jpg"
  },
  {
    "currency": "$",
    "price": 8,
    "id": "HI342",
    "name": "product",
    "description": "description",
    "imgUrl": "https://assets.adidas.com/images/w_320,h_320,f_auto,q_auto:sensitive,fl_lossy/807d251c686648de85f2abb10042fdf9_9366/GC7240_01_laydown.jpg"
  }
]
""".data(using: .utf8)!
