//
// Created by beop on 12/25/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class Meta: NSObject, NSCoding {
    var version: Int
    var condition_version: Int

    init(dictionary: [String: Any]) throws {
        print("Meta init(dictionary:) enter")
        print(dictionary)
        if dictionary["version"] != nil && dictionary["condition_version"] != nil {
            self.version = dictionary["version"] as! Int
            self.condition_version = dictionary["condition_version"] as! Int
        } else {
            throw ErrorsEnum.absentMetaProperty
        }
        super.init()
        print("Meta init(dictionary:) exit")

    }

    init(version: Int, condition: Int) {
        self.version = version
        self.condition_version = condition
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        version = (aDecoder.decodeInteger(forKey: "version"))
        condition_version = (aDecoder.decodeInteger(forKey: "condition_version") )
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(version, forKey: "version")
        aCoder.encode(condition_version, forKey: "condition_version")
    }
}
