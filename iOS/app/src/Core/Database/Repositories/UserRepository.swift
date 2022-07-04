//
//  UserRepository.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/9/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase
import FirebaseFirestore

public enum UserDocumentProp {
    case firstName
    case lastName
    case birthDate
    case email
    case stripeCustomerId
    
    func value() -> String {
        switch self {
        case .firstName:
            return "firstName"
        case .lastName:
            return "lastName"
        case .birthDate:
            return "birthDate"
        case .email:
            return "email"
        case .stripeCustomerId:
            return "stripeCustomerId"
        }
    }
}

struct UserRepository {
    private static let collection = "users"
    
    private static func addUpdateUser(user: UserModel, completion: @escaping (Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        
        let data: [String : Any] = [UserDocumentProp.stripeCustomerId.value(): user.stripeCustomerId as Any]
        
        db.collection(collection).document(CurrentUser.sharedInstance.uid!).setData(data) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    private static func getUser(uid: String, completion: @escaping (UserModel?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        
        db.collection(collection).document(uid).getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists else {
                completion(nil, nil)
                return
            }
            
            guard let userModel = modelInit(document, docId: document.documentID) else {
                completion(nil, DatabaseError.decode)
                return
            }
            
            completion(userModel, nil)
        }
    }
    
    private static func modelInit(_ doc: DocumentSnapshot, docId: String) -> UserModel? {
        //Make a mutable copy of the NSDictionary
        let dict = doc.data()
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict!, options: [])
            return try JSONDecoder().decode(UserModel.self, from: data)
        }
        catch let err {
            print("decode error \(err)")
            return nil
        }
    }
}
