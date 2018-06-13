//
// Created by beop on 5/31/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class RailRoadService {
    let rootUrl: String

    init() {
        self.rootUrl = "http://internal.novicorp.com:61885"
    }

    func getHTMLRequest(urlTail: String) -> Data? {
        var MyData: Data?
        guard let url = URL(string: self.rootUrl + urlTail) else {
            print("Can't make URL")
            return nil
        }
        var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData)
        urlRequest.httpMethod = "GET"
        let sessionConf = URLSessionConfiguration.default
        let session = URLSession.init(configuration: sessionConf)

        let semaphore = DispatchSemaphore(value: 0)

        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on " + urlTail)
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
                print(urlRequest)
                MyData = responseData
                semaphore.signal()
            }
        })
        task.resume()
        semaphore.wait()
        return MyData
    }

    func getVPNServers() -> [[String: Any]]? {

        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers")


        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return nil
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]
            return data
//            for elem in (data)! {
//                let bandwidth = elem["bandwidth"] as? Int
//                let condition_version = elem["condition_version"] as? Int
//                let load = elem["load"] as? Int
//                let status_id = elem["status_id"] as? Int
//                let type_id = elem["type_id"] as? Int
//                let string_uuid = elem["uuid"] as? String
//                let uuid = UUID.init(uuidString: string_uuid!)
//                let version = elem["version"] as? Int
//                let geo = elem["geo"] as? [String: Any]
//                let city_id = geo?["city_id"] as? Int
//                let country_code = geo?["country_code"] as? Int
//                let latitude = geo?["latitude"] as? String
//                let longitude = geo?["longitude"] as? String
//                let region_common = geo?["region_common"] as? Int
//                let region_dvd = geo?["region_dvd"] as? Int
//                let region_nintendo = geo?["region_nintendo"] as? Int
//                let region_playstation3 = geo?["region_playstation3"] as? Int
//                let region_playstation4 = geo?["region_playstation4"] as? Int
//                let region_xbox360 = geo?["region_xbox360"] as? Int
//                let region_xboxone = geo?["region_xboxone"] as? Int
//                let state_code = geo?["state_code"] as? Int
//            }
        }

    }

    func getMeta() {

        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/meta")


        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [String: Any]

            let version = data!["version"] as? Int
            let condition_version = data!["condition_version"] as? Int

        }

    }

    func getVPNServers(uuid: UUID) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/" + uuid.uuidString.lowercased())

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [String: Any]

            let version = data!["version"] as? Int
            let condition_version = data!["condition_version"] as? Int
            let bandwidth = data!["bandwidth"] as? Int
            let load = data!["load"] as? Int
            let status_id = data!["status_id"] as? Int
            let type_id = data!["type_id"] as? Int
            let string_uuid = data!["uuid"] as? String
            let uuid = UUID.init(uuidString: string_uuid!)
            let geo = data!["geo"] as? [String: Any]
            let city_id = geo!["city_id"] as? Int
            let country_code = geo!["country_code"] as? Int
            let latitude = geo!["latitude"] as? String
            let longitude = geo!["longitude"] as? String
            let region_common = geo!["region_common"] as? Int
            let region_dvd = geo!["region_dvd"] as? Int
            let region_nintendo = geo!["region_nintendo"] as? Int
            let region_playstation3 = geo!["region_playstation3"] as? Int
            let region_playstation4 = geo!["region_playstation4"] as? Int
            let region_xbox360 = geo!["region_xbox360"] as? Int
            let region_xboxone = geo!["region_xboxone"] as? Int
            let state_code = geo!["state_code"] as? Int
        }
    }

    func getVPNServers(status_id: Int) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/status/" + String(status_id))

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]

            for elem in data! {
                let version = elem["version"] as? Int
                let condition_version = elem["condition_version"] as? Int
                let bandwidth = elem["bandwidth"] as? Int
                let load = elem["load"] as? Int
                let status_id = elem["status_id"] as? Int
                let type_id = elem["type_id"] as? Int
                let string_uuid = elem["uuid"] as? String
                let uuid = UUID.init(uuidString: string_uuid!)
                let geo = elem["geo"] as? [String: Any]
                let city_id = geo?["city_id"] as? Int
                let country_code = geo?["country_code"] as? Int
                let latitude = geo?["latitude"] as? String
                let longitude = geo?["longitude"] as? String
                let region_common = geo?["region_common"] as? Int
                let region_dvd = geo?["region_dvd"] as? Int
                let region_nintendo = geo?["region_nintendo"] as? Int
                let region_playstation3 = geo?["region_playstation3"] as? Int
                let region_playstation4 = geo?["region_playstation4"] as? Int
                let region_xbox360 = geo?["region_xbox360"] as? Int
                let region_xboxone = geo?["region_xboxone"] as? Int
                let state_code = geo?["state_code"] as? Int
            }
        }
    }

    func getVPNServersConditions(status_id: Int) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/conditions/status/" + String(status_id))

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]

            for elem in data! {
                let version = elem["version"] as? Int
                let condition_version = elem["condition_version"] as? Int
                let bandwidth = elem["bandwidth"] as? Int
                let load = elem["load"] as? Int
                let status_id = elem["status_id"] as? Int
//                let type_id = elem["type_id"] as? Int
                let string_uuid = elem["uuid"] as? String
                let uuid = UUID.init(uuidString: string_uuid!)
            }
        }
    }

    func getVPNServers(type_id: Int) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/type/" + String(type_id))

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]
            for elem in data! {
                let version = elem["version"] as? Int
                let condition_version = elem["condition_version"] as? Int
                let bandwidth = elem["bandwidth"] as? Int
                let load = elem["load"] as? Int
                let status_id = elem["status_id"] as? Int
                let type_id = elem["type_id"] as? Int
                let string_uuid = elem["uuid"] as? String
                let uuid = UUID.init(uuidString: string_uuid!)
                let geo = elem["geo"] as? [String: Any]
                let city_id = geo!["city_id"] as? Int
                let country_code = geo!["country_code"] as? Int
                let latitude = geo!["latitude"] as? String
                let longitude = geo!["longitude"] as? String
                let region_common = geo!["region_common"] as? Int
                let region_dvd = geo!["region_dvd"] as? Int
                let region_nintendo = geo!["region_nintendo"] as? Int
                let region_playstation3 = geo!["region_playstation3"] as? Int
                let region_playstation4 = geo!["region_playstation4"] as? Int
                let region_xbox360 = geo!["region_xbox360"] as? Int
                let region_xboxone = geo!["region_xboxone"] as? Int
                let state_code = geo!["state_code"] as? Int
            }
        }
    }

    func getVPNServersConditions(type_id: Int) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/conditions/type/" + String(type_id))

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]
            for elem in data! {
                let version = elem["version"] as? Int
                let condition_version = elem["condition_version"] as? Int
                let bandwidth = elem["bandwidth"] as? Int
                let load = elem["load"] as? Int
                let status_id = elem["status_id"] as? Int
//            let type_id = elem["type_id"] as? Int
                let string_uuid = elem["uuid"] as? String
                let uuid = UUID.init(uuidString: string_uuid!)
            }
        }
    }

    func getVPNServersConditions(uuid: UUID) {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/conditions/" + uuid.uuidString.lowercased())

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [String: Any]

            let version = data!["version"] as? Int
            let condition_version = data!["condition_version"] as? Int
            let bandwidth = data!["bandwidth"] as? Int
            let load = data!["load"] as? Int
            let status_id = data!["status_id"] as? Int
            let string_uuid = data!["uuid"] as? String
            let uuid = UUID.init(uuidString: string_uuid!)

        }
    }

    func getVPNServersConditions() {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/conditions")

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [[String: Any]]
            for elem in data! {
                let version = elem["version"] as? Int
                let condition_version = elem["condition_version"] as? Int
                let bandwidth = elem["bandwidth"] as? Int
                let load = elem["load"] as? Int
                let status_id = elem["status_id"] as? Int
                let string_uuid = elem["uuid"] as? String
                let uuid = UUID.init(uuidString: string_uuid!)
            }
        }
    }

    func getVPNServerConfig(uuid: UUID) -> [String: Any]? {
        let responseData = getHTMLRequest(urlTail: "/api/v1/vpns/servers/" + uuid.uuidString.lowercased())

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return nil
        } else {
            print(json)
            let status = json!!["status"] as? String

            let data = json!!["data"] as? [String: Any]
//            let string_uuid = data!["uuid"] as? String
//            let uuid = UUID.init(uuidString: string_uuid!)
//            let string_user_uuid = data!["user_uuid"] as? String
//            let user_uuid = UUID.init(uuidString: string_user_uuid!)
//            let string_server_uuid = data!["server_uuid"] as? String
//            let server_uuid = UUID.init(uuidString: string_server_uuid!)
//            //todo convert base64 config to smthing
//            let configuration = data!["configuration"] as? String
//            let version = data!["version"] as? Int
//
           return data
        }
    }

    //todo (in development) func getRandomVPNServer

//    func test() {
//        let cache = NSCache<NSString, NSDictionary>.init()
//        cache.setObject(<#T##obj: NSDictionary##Foundation.NSDictionary#>, forKey: <#T##NSString##Foundation.NSString#>)
//    }

}
