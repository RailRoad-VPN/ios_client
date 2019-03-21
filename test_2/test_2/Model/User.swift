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
    private var isLocked: Bool?
    private var isExpired: Bool?
    private var userDevice: UserDevice?
    private var currentConnectionUUID: String?


    override init() {
        print_f(#file, #function, "init user from settings start")
        super.init()
        let user = CacheMetaService.shared.readAny(fromFile: FilesEnum.user.rawValue) as? User
        self.uuid = user?.uuid
        self.email = user?.email
        self.createdDate = user?.createdDate

        self.userDevice = UserDevice()
        print_f(#file, #function, "init user from settings end")

    }

    init(uuid: String, email: String, createdDate: String) {
        self.uuid = uuid
        self.email = email
        self.createdDate = createdDate
        self.userDevice = UserDevice()
        super.init()
    }

    init(dictionary: [String: Any]) throws {
        print_f(#file, #function, "init user from dictionary start")
        if (dictionary["uuid"] != nil &&
                (dictionary["email"] != nil) &&
                (dictionary["created_date"] != nil) &&
                (dictionary["enabled"] != nil)
           ) {
            self.uuid = (dictionary["uuid"] as! String)
            self.email = (dictionary["email"] as! String)
            self.createdDate = (dictionary["created_date"] as! String)
            self.isEnabled = (dictionary["enabled"] != nil)
            self.isLocked = dictionary["is_locked"] as? Bool
            self.isExpired = dictionary["is_expired"] as? Bool
        } else {
            throw ErrorsEnum.absentUserProperty
        }

        super.init()
        print_f(#file, #function, "user properties:")
        print_f(#file, #function, uuid)
        print_f(#file, #function, email)
        print_f(#file, #function, createdDate)
        print_f(#file, #function, isEnabled)
        print_f(#file, #function, "init user from dictionary end")
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

    func getIsLocked() -> Bool? {
        return self.isLocked
    }

    func getIsExpired() -> Bool? {
        return self.isExpired
    }

    func getUserDevice() -> UserDevice? {
        return self.userDevice
    }
    func getCurrentConnectionUUID() -> String? {
        return self.currentConnectionUUID
    }

    public func setIsEnabled(isEnabled: Bool){
        self.isEnabled = isEnabled
    }
    public func setIsLocked(isLocked: Bool){
        self.isLocked = isLocked
    }
    public func setIsExpired(isExpired: Bool){
        self.isExpired = isExpired
    }

    public func setUserDevice(userDevice: UserDevice) {
        print_f(#file, #function, "setUserDevice start")
        self.userDevice = userDevice
        print_f(#file, #function, "setUserDevice end")
    }
    public func setCurrentConnectionUUID(currentConnectionUUID: String) {
        print_f(#file, #function, "setCurrentConnectionUUID start")
        self.currentConnectionUUID = currentConnectionUUID
        print_f(#file, #function, "setCurrentConnectionUUID end")
    }

    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.createdDate = aDecoder.decodeObject(forKey: "createdDate") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(createdDate, forKey: "createdDate")
    }
}
