//
//  UIDeviceExtension.swift
//  cleafychallenge
//
//  Created by SERTORIG on 14/12/21.
//

import UIKit

extension UIDevice {
    var isJailbroken: Bool {
        get {
            if JailBrokenHelper.hasCydiaInstalled() { return true }
            if JailBrokenHelper.isContainsSuspiciousApps() { return true }
            if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
            return JailBrokenHelper.canEditSystemFiles()
        }
    }
}
