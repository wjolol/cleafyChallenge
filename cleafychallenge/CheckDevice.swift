//
//  CheckDevice.swift
//  cleafychallenge
//
//  Created by SERTORIG on 13/12/21.
//

import Foundation
 
//MARK: - Enum for the security result
private enum SecurityResult {
    case aa //ok
    case bb //deviceRooted
    case cc //deviceEmulated
    case dd //oldOsVersion
    case ee //activeVpnConnection
    case ff //packageNameTooLong
}

//MARK: - Enum for the start result
/*
    If all the security checks are ok and the api returns the list of stargazers then the sdk returns ok with the list of users.
    If a security check fails or the api has a problem receiving the list of users then the sdk will return failure with an error message if present.
*/
public enum StartResult {
    case ok([String]?)
    case failure(String?)
}

public class CheckDevice {
    
    private var checkDeviceModel: CheckDeviceModel?
    
    public init () {
        checkDeviceModel = CheckDeviceModel()
    }
    
    //MARK: - Start function that takes the owner and repository name as parameters that will be used to call the api in case all the security checks are ok, this function then returns the result with a completion
    public func start(owner: String, repoName: String, completion: @escaping (StartResult) -> Void) {
        
        switch verifySecurity() {
        case .aa:
            //If the security checks pass then we call the api to get the list of stargazers, if there are problems with the api the completion will return .failure with a message
            checkDeviceModel?.fetchStargazers(owner: owner, repoName: repoName) { response in
                completion(response)
            }
        default:
            //If one of the security checks has failed so we return the .failure with an error message to be used on the app
            completion(.failure(checkDeviceModel?.errorString))
        }

    }

    //MARK: - This function performs the security checks and returns the result to the start function
    private func verifySecurity() -> SecurityResult {
        if SecurityHelper.isSimulator() {
            checkDeviceModel?.errorString = "This app cannot be used on simulator."
            return .cc
        } else if SecurityHelper.hasJailbreak() {
            checkDeviceModel?.errorString = "This device could have malefic software installed.\nPlease remove it before using the app."
            return .bb
        } else if SecurityHelper.checkBundleLenght() {
            checkDeviceModel?.errorString = "This app could be compromised.\nPlease contact the customer support."
            return .ff
        } else if SecurityHelper.checkOsVersion() {
            checkDeviceModel?.errorString = "This app is not compatible with the iOS version installed on the device."
            return .dd
        } else if SecurityHelper.hasVpnActive() {
            checkDeviceModel?.errorString = "For security reasons this app cannot be used while having an active vpn connection."
            return .ee
        }
        return .aa
    }

}
