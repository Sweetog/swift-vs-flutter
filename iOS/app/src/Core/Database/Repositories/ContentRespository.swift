//
//  ContentRespository.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/12/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase
import CodableFirebase

struct ContentRepository {
    private static let collection = "content"
    
    static func getById(contentId: String, completion: @escaping (ContentModel?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(contentId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()!
                guard let contentModel = modelInit(data, docId: document.documentID) else {
                    completion(nil, DatabaseError.decode)
                    return
                }
                
                completion(contentModel, nil)
                
            } else {
                completion(nil, DatabaseError.notExist)
            }
        }
    }
    
    private static func modelInit(_ dict: [String: Any], docId: String) -> ContentModel? {
        do {
            let decoder = FirestoreDecoder()
            var model = try decoder.decode(ContentModel.self, from: dict)
            
            model.id = docId
            return model
        }
        catch let err {
            debugPrint("decode error \(err)")
            return nil
        }
    }
}
