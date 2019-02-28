//
// Created by beop on 12/2/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class RESTResponse {
    var isSuccess: Bool
    var statusCode: Int?
    var data: [String: Any]?
    var dataArray: [[String: Any]]?
    var header: [String: String]?
    var isClientError: Bool?
    var errorMessage: String?

    init() {
        self.isSuccess = false
    }

    func builder(isSuccess: Bool) -> RESTResponse {
        self.isSuccess = isSuccess
        return self
    }

    func builder(response: [String: String]) -> RESTResponse {
        self.header = response
        return self
    }

    func builder(data: [String: Any]) -> RESTResponse {
        self.data = data
        return self
    }

    func builder(dataArray: [[String: Any]]) -> RESTResponse {
        self.dataArray = dataArray
        return self
    }

    func builder(statusCode: Int) -> RESTResponse {
        self.statusCode = statusCode
        return self
    }

    func builder(isClientError: Bool) -> RESTResponse {
        self.isClientError = isClientError
        return self
    }

    func builder(errorMessage: String) -> RESTResponse {
        self.errorMessage = errorMessage
        return self
    }
}
