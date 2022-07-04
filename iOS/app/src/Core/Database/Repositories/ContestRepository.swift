//
//  ContestRepository.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/31/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

import Firebase
import CodableFirebase

struct ContestRepository {
    private static let collection = "contests"
    
    static func getById(contestId: String, completion: @escaping (ContestModel?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        let docRef = db.collection(collection).document(contestId)
        
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
    
    static func getToday(completion: @escaping ([ContestModel]?, Error?) -> Swift.Void) {
        let db = Firestore.firestore()
        let contestsRef = db.collection(collection)
        let query = contestsRef.whereField("startDate", isDateIn30Days: Date())
        
        var ret = [ContestModel]()

        query.getDocuments { (snapshot, error) in
            if let error = error {
               completion(nil, error)
                return
            }
            
            var currentCourseModel: CourseModel?
            let myGroup = DispatchGroup()
            
            for document in snapshot!.documents {
                myGroup.enter()
                guard var contest = modelInit(document.data(), docId: document.documentID) else {
                    myGroup.leave()
                    continue
                }
                
                guard let courseId = contest.courseId else {
                    myGroup.leave()
                    ret.append(contest)
                    continue
                }
                
                if currentCourseModel != nil && currentCourseModel!.id == courseId {
                    myGroup.leave()
                    contest.courseModel = currentCourseModel
                    ret.append(contest)
                    continue
                }
                
        
                CourseRepository.getById(courseId: courseId, completion: { (courseModel, error) in
                    myGroup.leave()
                    if let error = error {
                        print("error getting course \(error.localizedDescription)")
                        return
                    }
                    
                    currentCourseModel = courseModel
                    contest.courseModel = courseModel
                    ret.append(contest)
                })
            }
            
            myGroup.notify(queue: .main) {
                completion(ret, nil)
            }
        }
    }
    
    private static func modelInit(_ dict: [String: Any], docId: String) -> ContestModel? {
        do {
            let decoder = FirestoreDecoder()
            var model = try decoder.decode(ContestModel.self, from: dict)
            
            model.id = docId
            return model
        }
        catch let err {
            print("decode error \(err)")
            return nil
        }
    }
}
