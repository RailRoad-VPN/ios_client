//
// Created by beop on 12/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class UserDevice: NSObject, NSCoding {
    private var uuid: String?
    private var token: String?
    private var id: String?
    private var deviceIp: String?

    override init() {
        print_f(#file, #function, "init userDevice from settings start")
        super.init()
        let userDevice = CacheMetaService.shared.readAny(fromFile: FilesEnum.userDevice.rawValue) as? UserDevice
        self.uuid = userDevice?.uuid
        self.id = userDevice?.id
        self.token = userDevice?.token
        print_f(#file, #function, "init userDevice from settings end")
    }


    init(headers: [String: String], deviceId: String) throws {
        print_f(#file, #function, "init userDevice from dictionaries start")
        if (headers["Location"] != nil && headers["x-device-token"] != nil) {
            self.uuid = headers["Location"]?.split(separator: "/").suffix(1).joined(separator: "/")
            self.token = headers["x-device-token"]
        } else {
            throw ErrorsEnum.absentUserDeviceProperty
        }

        self.id = deviceId
        super.init()
        print_f(#file, #function, "uuid is: " + self.uuid!)
        print_f(#file, #function, "token is: " + self.token!)
        print_f(#file, #function, "id is: " + (self.id ?? "nil" ))
        print_f(#file, #function, "init userDevice from dictionaries end")
    }

    func setDeviceIp(deviceIp: String) {
        self.deviceIp = deviceIp
    }

    func getUuid() -> String? {
        return self.uuid
    }

    func getToken() -> String? {
        return self.token
    }

    func getId() -> String? {
        return self.id
    }

    func getDeviceIp() -> String? {
        return self.deviceIp
    }

    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.deviceIp = aDecoder.decodeObject(forKey: "deviceIp") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(deviceIp, forKey: "deviceIp")
    }


}