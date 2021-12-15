//
//  JailbreakHelper.swift
//  cleafychallenge
//
//  Created by SERTORIG on 14/12/21.
//
import UIKit

//MARK: - Here we have all the methods to check if the device has a jailbreak.
struct JailbreakHelper {
    
    //MARK: - These are some apps that are usually installed on jailbroken devices.
    static var pathsToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    //MARK: - These are some paths where the jailbreak usually writes file or creates new folder.
    static var systemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
    
    //MARK: - This function tries to open the cydia app, if it fails then probably there is no jailbreak on the device
    @inline(__always) static func isCydiaPresent() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }
    
    //MARK: - This function checks if there are suspicious app related to jailbreak installed on the device
    @inline(__always) static func checkForUnsecureApps() -> Bool {
        for path in pathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    //MARK: - This function checks if there are suspicious paths where the jailbreak usually writes files or creates new folders
    @inline(__always) static func checkForUnsecureSystemPaths() -> Bool {
        for path in systemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    //MARK: - This function tries to write on the file system, if it succeds then that means that the user has root permission that is disabled by default in iOS
    @inline(__always) static func writeIntoFileSytem() -> Bool {
        do {
            try "writingTest".write(toFile: "writingTest", atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
}
