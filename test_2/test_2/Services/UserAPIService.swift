//
// Created by beop on 12/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class UserAPIService: RESTService {

    var user = User()

    let url = GlobalSettings.getServiceURL(serviceName: "users")


    func receiveUser(pincode: String) throws -> User {

        let response: RESTResponse

        let headers = prepareHeaders()

        response = get(url: url + "/pincode/" + pincode, headers: headers)

        if response.isSuccess {
            do {
                let user = try User(dictionary: (response.data)!)
                print("receiveUser before return")
                self.user = user
                return user
            } catch ErrorsEnum.absentUserProperty {
                print("throw userAPIServiceSystemError")
                throw ErrorsEnum.userAPIServiceSystemError
            }
        } else if response.isClientError == true && response.statusCode! < 500 {
            print("throw userAPIServiceWrongPin")
            throw ErrorsEnum.userAPIServiceWrongPin
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    func receiveRandomVPNServer() throws -> String {
        print("getRandomVPNServer start")
        if user.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        let userUuid = user.getUuid()!
        var response = RESTResponse()

        let headers = prepareHeaders()

        response = get(url: url + "/" + userUuid + "/servers?random", headers: headers)

        if response.isSuccess {
            if let serverUuid = response.data!["uuid"] as? String {
                print("serverUuid is:" + serverUuid)
                print("getRandomVPNServer end")
                return serverUuid
            } else {
                throw ErrorsEnum.userAPIServiceSystemError
            }
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    func receiveVPNConfigurationByUserAndServer(serverUuid: String) throws -> String {
        print("receiveVPNConfigurationByUserAndServer start")
        if user.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

// TODO check specific meta of server and take from cache
        let userUuid = user.getUuid()!
        var response = RESTResponse()

        let headers = prepareHeaders()

        response = get(url: "\(url)/\(userUuid)/servers/\(serverUuid)/configurations?vpn_type_id=\(GlobalSettings.VPN_TYPE_ID)&platform_id=\(GlobalSettings.DEVICE_PLATFORM_ID)", headers: headers)

        if response.isSuccess {
            if let config = response.data!["configuration"] as? String {
                print("config:" + config)
                print("receiveVPNConfigurationByUserAndServer end")
                return config
            } else {
                throw ErrorsEnum.userAPIServiceSystemError
            }
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    func createUserDevice() throws -> UserDevice {
        print("createUserDevice start")
        if user.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        let userUuid = user.getUuid()!
        print("create user device with user_uuid: " + userUuid)

        var response = RESTResponse()
        let headers = prepareHeaders()
        var deviceId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        deviceId.append("P")


        let bodyJson: [String: Any] = [
            "user_uuid": userUuid,
            "device_id": deviceId,
            "platform_id": GlobalSettings.DEVICE_PLATFORM_ID,
            "vpn_type_id": GlobalSettings.VPN_TYPE_ID,
            "is_active": true
        ]

        response = post(url: "\(url)/\(userUuid)/devices", headers: headers, body: bodyJson)

        if response.isSuccess {
            do {
                let userDevice = try UserDevice(headers: response.header!, deviceId: deviceId)
                self.user.setUserDevice(userDevice: userDevice)
                print("createUserDevice end")
                return userDevice
            } catch ErrorsEnum.absentUserDeviceProperty {
                throw ErrorsEnum.userAPIServiceSystemError
            }
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    func updateUserDevice(virtualIp: String, deviceIp: String, location: String) throws {
        print("updateUserDevice start")
        if user.getUuid() == nil || user.getUserDevice()?.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        let userUuid = user.getUuid()!
        let userDeviceUuid = user.getUserDevice()!.getUuid()!
        print("updateUserDevice with user_uuid: " + userUuid + "and ips...")

        var response = RESTResponse()
        let headers = prepareHeaders()

        let bodyJson: [String: Any] = [
            "uuid": userDeviceUuid,
            "user_uuid": userUuid,
            "virtual_ip": virtualIp,
            "device_ip": deviceIp,
            "is_active": true,
            "location": location,
            "device_id": user.getUserDevice()!.getId()!,
            "platform_id": GlobalSettings.DEVICE_PLATFORM_ID,
            "vpn_type_id": GlobalSettings.VPN_TYPE_ID,
            "modify_reason": "set virtual ip"
        ]

        response = put(url: "\(url)/\(userUuid)/devices/\(userDeviceUuid)", headers: headers, body: bodyJson)

        if response.isSuccess {
            print("updateUserDevice end")
            return
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    public func deleteUserDevice() throws {
        print("deleteUserDevice enter")
        if user.getUuid() == nil || user.getUserDevice()?.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        let userUuid = user.getUuid()!
        let userDeviceUuid = user.getUserDevice()!.getUuid()!

        var response = RESTResponse()
        let headers = prepareHeaders()

        let bodyJson = [
            "uuid": userDeviceUuid,
            "user_uuid": userUuid,
            "modify_reason": "log_out"
        ]

        response = delete(url: "\(url)/\(userUuid)/devices/\(userDeviceUuid)", headers: headers, body: bodyJson)

        if response.isSuccess {
            print("deleteUserDevice end")
            return
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }

    }


// TODO probably another service
    func createConnection(serverUuid: String, virtualIp: String, deviceIp: String) throws -> String {
        print("createConnection start")
        if user.getUuid() == nil || user.getUserDevice()?.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        var response = RESTResponse()
        let headers = prepareHeaders()

        let userUUID = user.getUuid()!

        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let connected_since = dateFormatter.string(from: Date())

        let postJson: [String: Any] = [
            "server_uuid": serverUuid,
            "user_uuid": userUUID,
            "user_device_uuid": user.getUserDevice()!.getUuid() as Any,
            "device_id": user.getUserDevice()!.getId()!,
            "device_ip": deviceIp,
            "virtual_ip": virtualIp,
            "bytes_i": 0,
            "bytes_o": 0,
            "connected_since": connected_since,
            "is_connected": true
        ]

        response = post(url: "\(self.url)/\(userUUID)/servers/\(serverUuid)/connections",
                headers: headers, body: postJson)

        if response.isSuccess {
            self.user.setCurrentConnectionUUID(currentConnectionUUID: (response.header!["Location"]?.split(separator: "/").suffix(1).joined(separator: "/"))!)
            print("createConnection end")
            return user.getCurrentConnectionUUID()!
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }

    // TODO probably another service
    func updateConnection(connectionUUID: String, serverUuid: String, bytes_i: Int, bytes_o: Int, isConnected: Bool) throws {
        print("createConnection start")
        if self.user.getCurrentConnectionUUID() == nil || self.user.getUserDevice()?.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        var response = RESTResponse()
        let headers = prepareHeaders()

        let postJson: [String: Any] = [
            "server_uuid": serverUuid,
            "user_device_uuid": self.user.getUserDevice()!.getUuid()!,
            "bytes_i": bytes_i,
            "bytes_o": bytes_o,
            "is_connected": isConnected
        ]

        response = put(url: "\(self.url)/\(self.user.getUuid()!)/servers/\(serverUuid)/connections/\(self.user.getCurrentConnectionUUID()!)",
                headers: headers, body: postJson)

        if response.isSuccess {
            print("createConnection end")
            return
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }


// TODO probably another service
    func getVPNServers() throws -> [Server] {
        print("getVPNServers enter")

        if user.getUuid() == nil || user.getUserDevice()?.getUuid() == nil {
            throw ErrorsEnum.userAPIServiceSystemError
        }

        var response = RESTResponse()
        let headers = prepareHeaders()

        response = get(url: "\(url)/\(user.getUuid()!)/servers",
                headers: headers)

        if response.isSuccess && response.dataArray != nil {
            var serversArray: [Server] = []

            for serverDict in response.dataArray! {
                let server = Server(dictionary: serverDict)
                serversArray.append(server)
                print("server information")
                print(server.uuid)
                print(server.num)
                print(server.city_id)
            }
            print("updateUserDevice end")
            return serversArray
        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } else {
            print("throw userAPIServiceSystemError")
            throw ErrorsEnum.userAPIServiceSystemError
        }
    }


    private func prepareHeaders() -> [String: String] {
        let authToken = UtilityService.generateAuthToken()

        var headers = ["X-Auth-Token": authToken]
        if user.getUserDevice()?.getToken() != nil {
            headers["X-Device-Token"] = user.getUserDevice()!.getToken()
        }
        return headers
    }
}
