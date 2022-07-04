//
//  CourseRepository.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase
import CodableFirebase

struct CourseRepository {
    private static let collection = "courses"
    
    static func getById(courseId: String, completion: @escaping (CourseModel?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(courseId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()!
                guard let course = modelInit(data, docId: document.documentID) else {
                    completion(nil, DatabaseError.decode)
                    return
                }
                
                completion(course, nil)
                
            } else {
                completion(nil, DatabaseError.notExist)
            }
        }
    }
    
    static func get(completion: @escaping ([CourseModel]?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        var courses = [CourseModel]()
        
        db.collection(collection)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil, err)
                    return
                }
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    guard let course = modelInit(document.data(), docId: document.documentID) else {
                        completion(nil, DatabaseError.decode)
                        return
                    }
                    
                   courses.append(course)
                }
                
                completion(courses, nil)
        }
    }
    
    private static func modelInit(_ dict: [String: Any], docId: String) -> CourseModel? {
        do {
            let decoder = FirestoreDecoder()
            let model = try decoder.decode(CourseModel.self, from: dict)
            
            model.id = docId
            return model
        }
        catch let err {
            debugPrint("decode error \(err)")
            return nil
        }
    }
}

public enum ContestRefDocumentProp {
    case contestId

    func value() -> String {
        switch self {
        case .contestId:
            return "contestId"
        }
    }
}
