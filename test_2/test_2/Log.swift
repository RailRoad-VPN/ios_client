//
// Created by beop on 2/28/19.
// Copyright (c) 2019 beop. All rights reserved.
//

import Foundation

class Log: TextOutputStream {

    public static var log: Log = Log()

    private init() {
    }


    func write(_ string: String) {
        print(string, terminator: "")

        let log = getPathToLog()
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }

    func getPathToLog() -> URL {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.string(from: Date())

        let logFileName = "log_\(date).log"

        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logFileName)
        return log
    }

    static func getPathToLog() -> URL {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.string(from: Date())

        let logFileName = "log_\(date).log"

        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(logFileName)
        return log
    }
}

public func print_f(_ file: String, _ items: Any...) {
    var splittedFile = file.split(separator: "/").suffix(1).joined(separator: "/")
    print(Date(), splittedFile, items, separator: ": ", to: &Log.log)
}
