//
//  PurchaseRepository.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/4/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase
import CodableFirebase

struct PurchaseRepository {
    private static let collection = "purchases"
    
    static func queryPurchases(completion: @escaping ([PurchaseModel]?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        var purchases = [PurchaseModel]()
        let purchasesRef = db.collection(collection)
        let query = purchasesRef.order(by: "timestamp", descending: true)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil, err)
                return
            }
            
            for document in querySnapshot!.documents {

                
                guard let purchase = modelInit(document.data(), docId: document.documentID) else {
                    completion(nil, DatabaseError.decode)
                    return
                }
                
                if purchase.userId == "iPZi6t3cLhXRSvAH01MGnkI1XbM2" || purchase.userId == "2Lvpbct7mpN6Gbqsy3yVAxAncn12" || purchase.userId == "xlhxeQoOvFRCIdFZqO1f2zILTem2" || purchase.userId == "e5YeDwhQqohzr4kw2XpRk6JjAk72" {
                    continue
                }

                
                print("\(purchase.userId) => \(purchase.timestamp.dateValue().toYearMonthDay())")
                
                purchases.append(purchase)
            }
            
            print("purchases count: \(purchases.count)")
            completion(purchases, nil)
        }
    }
    
    static func getByUserId(userId:String, completion: @escaping ([PurchaseModel]?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        var purchases = [PurchaseModel]()
        let purchasesRef = db.collection(collection)
        let query = purchasesRef.whereField("userId", isEqualTo: userId).order(by: "timestamp", descending: true)
        
       query.getDocuments() { (querySnapshot, err) in
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
                    
                    purchases.append(course)
                }
                
                completion(purchases, nil)
        }
    }
    
    private static func modelInit(_ dict: [String: Any], docId: String) -> PurchaseModel? {
        do {
            let decoder = FirestoreDecoder()
            let model = try decoder.decode(PurchaseModel.self, from: dict)
            
            model.id = docId
            return model
        }
        catch let err {
            debugPrint("decode error \(err)")
            return nil
        }
    }
}
