//
// Created by beop on 12/2/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class RESTService: RESTServiceI {

//    init() {
//
//    }

    func get(url: String, headers: [String: String]?) -> (RESTResponse) {
        debugPrint("RESTService get method with URL: " + url + " and headers: ")
        debugPrint(headers)
        var returnRESTResponse = RESTResponse()

        let url = URL(string: url)!


        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        request.httpMethod = "GET"

        if headers != nil {
            for header in headers! {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        let sessionConf = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConf)

        let semaphore = DispatchSemaphore(value: 0)

        let task = session.dataTask(with: request, completionHandler: {
            (body, response, error) in
            print("calling GET on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: body, response: response, error: error)
            semaphore.signal()
            return
        })

        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 310.0) == .timedOut {
            print("TIMEOUT")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }

        return returnRESTResponse
    }

    func post(url: String, headers: [String: String]?, body: [String: Any]?) -> (RESTResponse) {
        debugPrint("RESTService post method with URL: " + url + " and headers: ")
        debugPrint(headers)
        debugPrint("and body: ")
        debugPrint(body)

        var returnRESTResponse = RESTResponse()

        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"

        if headers != nil {
            for header in headers! {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        try! print(String(data: jsonData!, encoding: String.Encoding.utf8))

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("calling POST on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: data, response: response, error: error)
            semaphore.signal()
            return
        }
        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 20.0) == .timedOut {
            print("timeout")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }

        return returnRESTResponse
    }

    func put(url: String, headers: [String: String]?, body: [String: Any]?) -> (RESTResponse) {
        debugPrint("RESTService put method with URL: " + url + " and headers: ")
        debugPrint(headers)
        debugPrint("and body: ")
        debugPrint(body)

        var returnRESTResponse = RESTResponse()

        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PUT"

        if headers != nil {
            for header in headers! {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("calling PUT on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: data, response: response, error: error)
            semaphore.signal()
            return
        }

        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 20.0) == .timedOut {
            print("timeout")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }


        return returnRESTResponse
    }

    func delete(url: String, headers: [String: String]?, body: [String: Any]?) throws -> (RESTResponse) {
        return RESTResponse()

    }

    func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> RESTResponse {
        print("parseResponse start")
        debugPrint(data)
        debugPrint(response)
        debugPrint(error)

        let restResponse = RESTResponse()

        let statusCode: Int?
        var httpResponse: HTTPURLResponse?

        if error != nil {
            restResponse.builder(errorMessage: error!.localizedDescription)
            print("ERROR: " + error!.localizedDescription)
        } else {
            httpResponse = (response as! HTTPURLResponse)
            statusCode = httpResponse!.statusCode
            restResponse.builder(statusCode: statusCode!).builder(response: httpResponse!.allHeaderFields as! [String: String])

            print("Check status code")
            if statusCode! >= 200 && statusCode! < 400 {
                print("success status code")
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    if json!["data"] != nil {
                        if let dictData = json!["data"] as? [String: Any] {
                            restResponse.builder(data: dictData)
                        } else if let dictArrayData = json!["data"] as? [[String: Any]] {
                            restResponse.builder(dataArray: dictArrayData)
                        }
                    }

                    restResponse.builder(isSuccess: true)
                } catch let error {
                    print("json error: \(error)")
                }
            } else if statusCode! >= 400 && statusCode! < 500 {
//client error
                print("client error status code")
                restResponse.builder(errorMessage: String(data: data!, encoding: .utf8)!)
                        .builder(isSuccess: false).builder(isClientError: true)
                debugPrint(restResponse.errorMessage)
            } else if statusCode! >= 500 && statusCode! < 600 {
//server error
                print("server error status code")
                restResponse.builder(errorMessage: String(data: data!, encoding: .utf8)!)
                        .builder(isSuccess: false).builder(isClientError: false)
                debugPrint(restResponse.errorMessage)
            }
        }
        print("parseResponse end")
        return restResponse
    }
}
