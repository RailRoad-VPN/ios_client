//
// Created by beop on 5/31/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let refreshTableView = Notification.Name("refreshTableView")
}

class RailRoadService {
    let rootUrl: String
    let dir: URL?
    var isVpnOn: Bool
    var metaCached: [String: Any]?


    init() {
        rootUrl = "http://internal.novicorp.com:61885"
        isVpnOn = false
        dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        metaCached = readDict(fromFile: FilesEnum.meta.rawValue)

    }

    func getRequest(urlTail: String) -> Data? {
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
                semaphore.signal()
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
        if semaphore.wait(timeout: DispatchTime.now() + 10.0) == .timedOut {
            print("TIMEDOUT")
            //throw ErrorsEnum.timedOut
        }
        return MyData
    }

    func postRequest(urlTail: String, data: Data) {
        let url = URL(string: rootUrl + urlTail)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                semaphore.signal()
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            semaphore.signal()
        }
        task.resume()
        if semaphore.wait(timeout: DispatchTime.now() + 10.0) == .timedOut {
            print("TIMEDOUT")
            //throw ErrorsEnum.timedOut
        }
    }

    func getVPNServers() -> [[String: Any]]? {

        let responseData = getRequest(urlTail: "/api/v1/vpns/servers")

        if responseData == nil {
            return nil
        }

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

    func getMeta() -> [String: Any]? {

        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/meta")

        if responseData == nil {
            return nil
        }

        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return nil
        } else {
            print(json)
//            let status = json!!["status"] as? String

            let data = json!!["data"] as? [String: Any]
            return data
//            let version = data!["version"] as? Int
//            let condition_version = data!["condition_version"] as? Int

        }

    }

    func getVPNServers(uuid: UUID) {
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/" + uuid.uuidString.lowercased())

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/status/" + String(status_id))

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/conditions/status/" + String(status_id))

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/type/" + String(type_id))

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/conditions/type/" + String(type_id))

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/conditions/" + uuid.uuidString.lowercased())

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/conditions")

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
        let responseData = getRequest(urlTail: "/api/v1/vpns/servers/" + uuid.uuidString.lowercased())

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

    func getUser(pincode: String) -> [String: Any]? {
        let responseData = getRequest(urlTail: "/api/v1/users/pincode/" + pincode)
        let json = try? JSONSerialization.jsonObject(with: responseData!) as? [String: Any]
        if (json == nil) {
            print("error json")
            return nil
        } else if (json??["status"] as? String) != "success" {
            print("error")
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

    func postDevice(user_uuid: String) {
        let postJson: [String: Any] = ["user_uuid": user_uuid, "device_id": UUID().uuidString]
        let jsonData = try? JSONSerialization.data(withJSONObject: postJson)
        postRequest(urlTail: "/api/v1/users/" + user_uuid + "/devices", data: jsonData!)
//
    }

    //todo (in development) func getRandomVPNServer

    func save(anyDict: Any, toFile: String) {
        // Path to save array data

        let fileURL = self.dir!.appendingPathComponent(toFile)

        // write to file 2
        NSKeyedArchiver.archiveRootObject(anyDict, toFile: fileURL.path)
    }

    func readDictArray(fromFile: String) -> [[String: Any]]? {
        let fileURL = dir!.appendingPathComponent(fromFile)

        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [[String: Any]]
        print("-----------------------------------------------------")
        return dict
        print("-----------------------------------------------------")
    }

    func readDict(fromFile: String) -> [String: Any]? {
        let fileURL = dir!.appendingPathComponent(fromFile)
        //reading2
        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [String: Any]
        print("-----------------------------------------------------")
        return dict
        print("-----------------------------------------------------")
    }

    func updateRequestVPNServers(once: Bool = false) {
        while true {
            print("START OUR BACKGROUND WORK!!!")

            if isMetaOld() == true {
                save(anyDict: getVPNServers(), toFile: FilesEnum.vpnServers.rawValue)
                NotificationCenter.default.post(name: .refreshTableView, object: nil)
            }
            if (once) {
                return
            }

            let semaphore = DispatchSemaphore(value: 0)
            semaphore.wait(timeout: DispatchTime.now() + 20.0)

        }
    }


    func isMetaOld() -> Bool {
        if metaCached == nil {
            metaCached = getMeta()
            return true
        } else {
            let metaCachedVersion = metaCached!["version"] as? Int
            let metaCachedConditionVersion = metaCached!["contidion"] as? Int
            let metaRemote = getMeta()
            let metaRemoteVersion = metaRemote!["version"] as? Int
            let metaRemoteConditionVersion = metaRemote!["ConditionVersion"] as? Int

            if (metaCachedVersion != metaRemoteVersion) || (metaCachedConditionVersion != metaRemoteConditionVersion) {
                save(anyDict: metaRemote, toFile: FilesEnum.meta.rawValue)
                metaCached = metaRemote
                return true
            }
            return false
        }
    }

    func connectToVPN() {
        getVPNServerConfig(uuid: (UUID.init(uuidString: "c872e7f0-76d6-4a4e-826e-c56a7c05958a"))!)
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        isVpnOn = true
        print("connecting...")
    }

    func disconnectFromVPN() {
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        isVpnOn = false
        print("disconnecting...")
    }

}
