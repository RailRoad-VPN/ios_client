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
        print_f(#file, #function, "RESTService get method with URL: " + url + " and headers: ")
        print_f(#file, #function, headers)
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
            print_f(#file, #function, "calling GET on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: body, response: response, error: error)
            semaphore.signal()
            return
        })

        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 310.0) == .timedOut {
            print_f(#file, #function, "TIMEOUT")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }

        return returnRESTResponse
    }

    func post(url: String, headers: [String: String]?, body: [String: Any]?) -> (RESTResponse) {
        print_f(#file, #function, "RESTService post method with URL: " + url + " and headers: ")
        print_f(#file, #function, headers)
        print_f(#file, #function, "and body: ")
        print_f(#file, #function, body)

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
        print_f(#file, #function, String(data: jsonData!, encoding: String.Encoding.utf8) as Any)

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print_f(#file, #function, "calling POST on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: data, response: response, error: error)
            semaphore.signal()
            return
        }
        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 20.0) == .timedOut {
            print_f(#file, #function, "timeout")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }

        return returnRESTResponse
    }

    func put(url: String, headers: [String: String]?, body: [String: Any]?) -> (RESTResponse) {
        print_f(#file, #function, "RESTService put method with URL: " + url + " and headers: ")
        print_f(#file, #function, headers)
        print_f(#file, #function, "and body: ")
        print_f(#file, #function, body)

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
            print_f(#file, #function, "calling PUT on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: data, response: response, error: error)
            semaphore.signal()
            return
        }

        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 20.0) == .timedOut {
            print_f(#file, #function, "timeout")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }


        return returnRESTResponse
    }

    func delete(url: String, headers: [String: String]?, body: [String: Any]?) -> (RESTResponse) {
        print_f(#file, #function, "RESTService delete method with URL: " + url + " and headers: ")
        print_f(#file, #function, headers)
        print_f(#file, #function, "and body: ")
        print_f(#file, #function, body)

        var returnRESTResponse = RESTResponse()

        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "DELETE"

        if headers != nil {
            for header in headers! {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print_f(#file, #function, "calling PUT on " + url.absoluteString)
            returnRESTResponse = self.parseResponse(data: data, response: response, error: error)
            semaphore.signal()
            return
        }

        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 20.0) == .timedOut {
            print_f(#file, #function, "timeout")
            returnRESTResponse.builder(isClientError: true).builder(errorMessage: "timeout")
        }


        return returnRESTResponse

    }

    func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> RESTResponse {
        print_f(#file, #function, "parseResponse start")
        print_f(#file, #function, data)
        print_f(#file, #function, response)
        print_f(#file, #function, error)

        let restResponse = RESTResponse()

        let statusCode: Int?
        var httpResponse: HTTPURLResponse?

        if error != nil {
            restResponse.builder(errorMessage: error!.localizedDescription)
            print_f(#file, #function, "ERROR: " + error!.localizedDescription)
        } else {
            httpResponse = (response as! HTTPURLResponse)
            statusCode = httpResponse!.statusCode
            restResponse.builder(statusCode: statusCode!).builder(response: httpResponse!.allHeaderFields as! [String: String])

            print_f(#file, #function, "Check status code")
            if statusCode! >= 200 && statusCode! < 400 {
                print_f(#file, #function, "success status code")
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
                    print_f(#file, #function, "json error: \(error)")
                }
            } else if statusCode! >= 400 && statusCode! < 500 {
//client error
                print_f(#file, #function, "client error status code")
                restResponse.builder(errorMessage: String(data: data!, encoding: .utf8)!)
                        .builder(isSuccess: false).builder(isClientError: true)
                print_f(#file, #function, restResponse.errorMessage)
            } else if statusCode! >= 500 && statusCode! < 600 {
//server error
                print_f(#file, #function, "server error status code")
                restResponse.builder(errorMessage: String(data: data!, encoding: .utf8)!)
                        .builder(isSuccess: false).builder(isClientError: false)
                print_f(#file, #function, restResponse.errorMessage)
            }
        }
        print_f(#file, #function, "parseResponse end")
        return restResponse
    }
}
