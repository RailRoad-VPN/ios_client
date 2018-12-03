//
// Created by beop on 12/2/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

protocol RESTServiceI {
    func get(url: String, headers: [String: String]?) throws -> (RESTResponse)
    func post(url: String, headers: [String: String]?, body: [String: Any]?) throws -> (RESTResponse)
    func put(url: String, headers: [String: String]?, body: [String: Any]?) throws -> (RESTResponse)
    func delete(url: String, headers: [String: String]?, body: [String: Any]?) throws -> (RESTResponse)
}
