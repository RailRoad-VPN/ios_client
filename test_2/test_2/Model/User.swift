//
// Created by beop on 12/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    private var uuid: String?
    private var email: String?
    private var createdDate: String?
    private var isEnabled: Bool?
    private var userDevice: UserDevice?
    private var currentConnectionUUID: String?


    override init() {
        print("init user from settings start")
        super.init()
        let user = CacheMetaService.shared.readAny(fromFile: FilesEnum.user.rawValue) as? User
        self.uuid = user?.uuid
        self.email = user?.email
        self.createdDate = user?.createdDate
        self.isEnabled = user?.isEnabled

        self.userDevice = UserDevice()
        print("init user from settings end")

    }

    init(uuid: String, email: String, createdDate: String, isEnabled: Bool) {
        self.uuid = uuid
        self.email = email
        self.createdDate = createdDate
        self.isEnabled = isEnabled
        self.userDevice = UserDevice()
        super.init()
    }

    init(dictionary: [String: Any]) throws {
        print("init user from dictionary start")
        if (dictionary["uuid"] != nil &&
                (dictionary["email"] != nil) &&
                (dictionary["created_date"] != nil) &&
                (dictionary["enabled"] != nil)
           ) {
            self.uuid = (dictionary["uuid"] as! String)
            self.email = (dictionary["email"] as! String)
            self.createdDate = (dictionary["created_date"] as! String)
            self.isEnabled = (dictionary["enabled"] != nil)
        } else {
            throw ErrorsEnum.absentUserProperty
        }

        super.init()
        print("user properties:")
        print(uuid)
        print(email)
        print(createdDate)
        print(isEnabled)
        print("init user from dictionary end")
    }

    func getUuid() -> String? {
        return self.uuid
    }

    func getEmail() -> String? {
        return self.email
    }

    func getCreatedDate() -> String? {
        return self.createdDate
    }

    func getIsEnabled() -> Bool? {
        return self.isEnabled
    }

    func getUserDevice() -> UserDevice? {
        return self.userDevice
    }
    func getCurrentConnectionUUID() -> String? {
        return self.currentConnectionUUID
    }

    public func setUserDevice(userDevice: UserDevice) {
        print("setUserDevice start")
        self.userDevice = userDevice
        print("setUserDevice end")
    }
    public func setCurrentConnectionUUID(currentConnectionUUID: String) {
        print("setCurrentConnectionUUID start")
        self.currentConnectionUUID = currentConnectionUUID
        print("setCurrentConnectionUUID end")
    }

    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.createdDate = aDecoder.decodeObject(forKey: "createdDate") as? String
        self.isEnabled = aDecoder.decodeObject(forKey: "isEnabled") as? Bool
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(createdDate, forKey: "createdDate")
        aCoder.encode(isEnabled, forKey: "isEnabled")
    }
}
