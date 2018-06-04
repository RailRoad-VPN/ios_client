//
// Created by beop on 5/31/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class RailRoadService {
    let rootUrl: String

    init(){
        self.rootUrl = "http://internal.novicorp.com:61885"
    }

    func getVPNServers(){
        guard let url = URL(string: self.rootUrl + "/api/v1/vpns/servers") else {
          print ("Can't make URL")
          return
        }

        let urlRequest = URLRequest(url: url)

        let sessionConf = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConf)

        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /api/v1/vpns/servers")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                print (urlRequest)
                let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any]
                if ( json == nil ) {
                    print ("error json")
                } else {
                    print (json)
                    let status = json!!["status"] as? String

                    let data = json!!["data"] as? [[String: Any]]

                    for elem in (data)! {
                        let bandwidth = elem["bandwidth"] as? Int
                        let condition_version = elem["condition_version"] as? Int
                        let load = elem["load"] as? Int
                        let status_id = elem["status_id"] as? Int
                        let type_id = elem["type_id"] as? Int
                        let string_uuid = elem["uuid"] as? String
                        let uuid = UUID.init(uuidString: string_uuid!)

                        print (uuid)

                    }
                    print(status)

                }

////                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
//                        as? [Any] else {
//                    print("error trying to convert data to JSON")
//                    return
//                }
                // now we have the todo
                // let's just print it to prove we can access it
//                print("The todo is: " + todo.description)

                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
//                guard let status = todo["status"] as? String else {
//                    print("Could not get todo title from JSON")
//                    return
//                }
//                print("The title is: " + status)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }

        task.resume()
    }

}