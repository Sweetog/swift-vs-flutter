//
//  LibraryAPI.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/3/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



struct ErrorMessage {
    let message: String
    let code: Int
    let userInfo: [String: Any]?
    
    init(message: String, code: Int, userInfo: [String: Any]? = nil) {
        self.message = message
        self.code = code
        self.userInfo =  userInfo
    }
    
}

class LibraryAPI: NSObject {
    
    var manager = Alamofire.SessionManager.default
    
    // Setups the cookie and shared instance
    override init() {
        let defaultHeaders = manager.session.configuration.httpAdditionalHeaders ?? [:]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        manager = Alamofire.SessionManager(configuration: configuration)
    }

    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func getToken(_ completion: @escaping (String?, Error?) -> Swift.Void) {
        AuthUtility.getIdToken { (token, authError) in
            if authError != nil {
                completion(nil, authError)
                return
            }
            
            guard let token = token else {
                completion(nil, AuthError.tokenNil)
                return
            }
            
            completion(token, nil)
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}

extension DataResponse {
    func jsonError() -> ErrorMessage? {
        let json = JSON(data!)
        guard let message = json["error"]["message"].string, let code = json["error"]["code"].int else {
            return nil
        }
        return ErrorMessage(message: message, code: code)
    }
    
    func serverError() -> NSError? {
        let json = JSON(data!)
        guard let message = json["error"]["message"].string, let code = json["error"]["code"].int else {
            return nil
        }
        return NSError(domain: "", code: code, userInfo: ["message": message])
    }
}

let API = LibraryAPI()
