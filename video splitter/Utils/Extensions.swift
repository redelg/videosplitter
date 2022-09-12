//
//  Extensions.swift
//  video splitter
//
//  Created by Renzo Delgado on 17/07/22.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
