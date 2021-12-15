//
//  SecurityHelper.swift
//  cleafychallenge
//
//  Created by SERTORIG on 14/12/21.
//

import UIKit

//MARK: - Here we have all the methods to check if the OS and app are secure
struct SecurityHelper {
    
    //MARK: - This method checks if the app is running on a simulator
    @inline(__always) static func isSimulator() -> Bool {
        guard TARGET_IPHONE_SIMULATOR != 1 else { return true }
        
        return false
    }
    
    //MARK: - This method performs the checks to verify that the device is not jailbroken
    @inline(__always) static func hasJailbreak() -> Bool {
        guard !JailbreakHelper.isCydiaPresent() else { return true }
        guard !JailbreakHelper.checkForUnsecureSystemPaths() else { return true }
        guard !JailbreakHelper.checkForUnsecureApps() else { return true }
        guard !JailbreakHelper.writeIntoFileSytem() else { return true }
        
        return false
    }

    //MARK: - This method checks the bundle identifier lenght
    @inline(__always) static func checkBundleLenght() -> Bool {
        if let bundle = Bundle.main.bundleIdentifier?.count {
            guard bundle > 20 else { return false }
            return true
        }
        return true
    }
    
    //MARK: - This method check the os version of the device that is being used
    @inline(__always) static func checkOsVersion() -> Bool {
        let version = ProcessInfo().operatingSystemVersion.majorVersion
        guard version < 13 else { return false }
        return true
    }
    
    //MARK: - This method checks if the user has a vpn connection active while using the app
    @inline(__always) static func hasVpnActive() -> Bool {
        /*
         tap = works at data link layer and carries ethernet frames
        
         tun/utun = works at network layer and carries ip packets
         
         ipsec = encrypt the ip packet at the start of the tunnel, then the packet is decrypted at the end and forwarded two the destination
         
         ppp = point to point protocol that enables communications between two points
        */
        let vpnProtocols = ["tap", "tun", "ppp", "ipsec", "utun"]
        guard let networkSettings = CFNetworkCopySystemProxySettings() else { return false }
        let dict = networkSettings.takeRetainedValue() as NSDictionary
        guard let keys = dict["__SCOPED__"] as? NSDictionary,
                    let allKeys = keys.allKeys as? [String] else { return false }
                // Checking for tunneling protocols in the keys
                for key in allKeys {
                    for protocolId in vpnProtocols
                        where key.starts(with: protocolId) {
                        return true
                    }
                }
        return false
    }
    
}
