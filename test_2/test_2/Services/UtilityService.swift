//
// Created by beop on 12/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class UtilityService {

    public static func codeBase64(string: String) -> String {
        return Data(string.utf8).base64EncodedString()
    }

    public static func decodeBase64(string: String) throws -> String {
        if let data = Data(base64Encoded: string) {
            return String(data: data, encoding: .utf8)!
        } else {
            throw ErrorsEnum.utilityServiceUnableToDecodeBase64
        }
    }


    public static func generateAuthToken() -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
        print("uuid is: " + uuid)
        let randomInt = Int(arc4random_uniform(31) + 1)
        print("randomInt is: " + String(randomInt))
        let timeInterval = Int(Date().timeIntervalSince1970)
        print("present unixtime is: " + String(timeInterval))
        let dividedUnixtime = Double(timeInterval) / Double(randomInt)

        let rondedDividedUnixtimeString = String(format: "%.10f", dividedUnixtime)
        print("rondedDividedUnixtimeString is: " + rondedDividedUnixtimeString)
        let lenghtOfRondedDividedUnixtimeString = rondedDividedUnixtimeString.count
        print("lenghtOfRondedDividedUnixtimeString is: " + String(lenghtOfRondedDividedUnixtimeString))

        let leftSideToken = uuid.prefix(randomInt)
        print("leftSideToken is: " + leftSideToken)


        let index = uuid.index(uuid.endIndex, offsetBy: randomInt - uuid.count)
        let rightSideToken = uuid.suffix(from: index)
        print("rightSideToken is: " + rightSideToken)

        var randomIntString: String
        if randomInt < 9 {
            randomIntString = "0" + String(randomInt)
        } else {
            randomIntString = String(randomInt)
        }

        var lengthDividedUnixtimeString: String
        if lenghtOfRondedDividedUnixtimeString < 9 {
            lengthDividedUnixtimeString = "0" + String(lenghtOfRondedDividedUnixtimeString)
        } else {
            lengthDividedUnixtimeString = String(lenghtOfRondedDividedUnixtimeString)
        }
        let authToken = randomIntString + lengthDividedUnixtimeString + leftSideToken + rondedDividedUnixtimeString + rightSideToken

        print(authToken)
        return authToken
    }
}
