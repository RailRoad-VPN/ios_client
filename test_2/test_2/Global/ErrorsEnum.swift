//
// Created by beop on 6/14/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

enum ErrorsEnum: Error {
    case gerRequestTimedOut

    case absentUserProperty
    case absentUserDeviceProperty
    case absentMetaProperty

    case responseDataIsEmpty
    case RESTAPISystemError

    case userAPIServiceWrongPin
    case userAPIServiceSystemError
    case userAPIServiceApplicationError
    case userAPIServiceConnectionProblem

    case metaCacheServiceConnectionProblem
    case metaCacheServiceSystemError
    case metaCacheSystemError

    case utilityServiceUnableToDecodeBase64

    case VPNServiceSystemError


}
