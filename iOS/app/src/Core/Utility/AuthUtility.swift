//
//  AuthUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import Stripe

enum AuthorizationType {
    case Google
    case Facebook
    case Email
    case NotSet
}

struct FacebookPermission
{
    static let ID: String = "id"
    static let NAME: String = "name"
    static let EMAIL: String = "email"
    static let PROFILE_PIC: String = "picture"
    static let LAST_NAME: String = "last_name"
    static let FIRST_NAME: String = "first_name"
    static let PHONE: String = "phone"
    static let BIRTHDAY: String = "birthday"
    static let USER_FRIENDS: String = "user_friends"
    static let USER_BIRTHDAY: String = "user_birthday"
    static let PUBLIC_PROFILE: String = "public_profile"
}

struct AuthUtility {
    private static var _authorizationType = AuthorizationType.NotSet
    private static var fireBaseCredential:AuthCredential?
    private static let facebookProvider = "facebook.com"
    private static let googleProvider = "google.com"
    private static let fbPermissions = [FacebookPermission.PUBLIC_PROFILE, FacebookPermission.EMAIL]
    private static let fbFields = "\(FacebookPermission.FIRST_NAME), \(FacebookPermission.LAST_NAME) "
    
    private static let accountCreatedKey = "accountCreatedKey"
    static var accountCreated: Bool {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultBool(key: accountCreatedKey) else {
                return false
            }
            
            return retVal
        }
        set {
            UserDefaultsUtility.set(value: newValue, key: accountCreatedKey)
        }
    }
    
    static var authorizationType: AuthorizationType {
        get {
            return _authorizationType
        }
    }
    
    static func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func creationDate() -> Date? {
        return Auth.auth().currentUser?.metadata.creationDate
    }
    
    static func lastSignInDate() -> Date? {
        return Auth.auth().currentUser?.metadata.lastSignInDate
    }
    
    static func freshenCurrentUser(completion: @escaping (Error?) -> Swift.Void) {
        if !AuthUtility.isLoggedIn() {
            completion(AuthError.notLoggedIn)
            return
        }
        
        hydateCurrentUser(user: Auth.auth().currentUser) { (error) in
            completion(error)
        }
    }
    
    static func getIdToken(completion: @escaping (String?, Error?) -> Swift.Void) {
        guard let user =  Auth.auth().currentUser else {
            print("No Firebase User!")
            completion(nil, nil)
            return
        }
        
        user.getIDToken { (idToken, error) in
            if(error != nil ) {
                print("AuthUtiltiy, error retrieving token: \(error!.localizedDescription)")
                completion(nil, error)
                return
            }
            
            completion(idToken, nil);
        }
    }
    
    static func sendPasswordResetEmail(email: String, completion: @escaping (Error?) -> Swift.Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
           completion(error)
        }
    }
    
    static func firebaseSignIn(email: String, password: String, completion: @escaping (Error?) -> Swift.Void) {
        Auth.auth().fetchProviders(forEmail: email) { (providers, error) in
            if error != nil {
                completion(error)
                return
            }
            
            let fireBaseProvider = providers?.first(where: { $0 != self.facebookProvider && $0 != self.googleProvider})
            
            //existing Firebase account
            if fireBaseProvider != nil {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (authResult, error) in
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    if let user = authResult?.user {
                        print("Firebase Auth SignIn success \(user)")
                        self.hydateCurrentUser(user: user, completion: { (createCuError) in
                            if createCuError != nil {
                                completion(createCuError)
                                return
                            }
                            
                            completion(nil)
                        })
                    }else{
                        completion(nil)
                    }
                    
                })
            }else {
                completion(AuthError.existingUserCreateAccountAttempt)
            }
        }
    }
    
    static func updateFirebaseProfile(displayName: String, completion: @escaping (Error?) -> Swift.Void) {
        guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else {
            completion(AuthError.notLoggedIn)
            return
        }
        
        changeRequest.displayName = displayName
        
        //fire off async, doing noting if fails
        changeRequest.commitChanges(completion: { (error) in
            if error != nil {
                completion(error)
                print("error commit displayName change firebase: \(error!.localizedDescription) \(#function) in \(#file.components(separatedBy: "/").last ?? "")")
                return
            }
            
            CurrentUser.sharedInstance.displayName = displayName
            completion(nil)
        })
    }
    
    static func firebaseCreateAccount(displayName: String, email: String, password: String, isAge18: Bool, completion: @escaping (Error?) -> Swift.Void) {
        Auth.auth().fetchProviders(forEmail: email) { (providers, error) in
            if error != nil {
                completion(error)
                return
            }
            
            let fireBaseProvider = providers?.first(where: { $0 != self.facebookProvider && $0 != self.googleProvider})
            
            //existing Firebase account
            if fireBaseProvider != nil {
                completion(AuthError.existingUserCreateAccountAttempt)
            }else {
                //create new Firebase account
                Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    if let user = authResult?.user {
                        print("Firebase Auth Create Account Success success \(user)")
                        UserService.sharedInstance.createUser(email: email, isAge18: isAge18, completion: { (userModel, error) in
                            if let error = error {
                                print("error createUser: \(error.localizedDescription) \(#function) in \(#file.components(separatedBy: "/").last ?? "")")
                                if ErrorUtility.isHttpErrorCouldNotConnectToServer(error: error) {
                                    user.delete { deleteError in
                                        AuthUtility.logout()
                                        completion(error)
                                        return
                                    }
                                }
                            }
                            
                            CurrentUser.sharedInstance.uid = user.uid
                            CurrentUser.sharedInstance.email = user.email
                            
                            updateFirebaseProfile(displayName: displayName, completion: { (error) in
                                 completion(error)
                            })
                        })
                    }else{
                        completion(nil)
                    }
                    
                })
            }
        }
    }
    
    static func swapGoogleCredForFirebaseCred(_ authentication: GIDAuthentication, completion: @escaping (Error?) -> Swift.Void) {
        self._authorizationType = .Google
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        self.signInFirebaseAfterProviderCredSwap(credential: credential, completion: { (user, error) in
            if error != nil {
                completion(error)
                return
            }
            
            guard let user = user else{
                completion(nil)
                return
            }
            
            guard user.providerData.first(where: { $0.providerID == googleProvider }) != nil else {
                completion(nil)
                return
            }
            
            self.hydateCurrentUser(user: user, completion: { (createCuError) in
                if createCuError != nil {
                    completion(createCuError)
                    return
                }
                
                //old code to "extract" firstName and lastName
//                if let displayName = provider.displayName {
//                    let arr = displayName.components(separatedBy: " ")
//
//                    CurrentUser.sharedInstance.firstName = arr[0]
//                    CurrentUser.sharedInstance.lastName = arr[1]
//                }
                
                completion(nil)
            })
        })
        
    }
    
    static func swapFacebookCredForFirebaseCred(completion: @escaping (Error?) -> Swift.Void) {
        if(FBSDKAccessToken.current() == nil) {
            completion(nil)
            return
        }
        self._authorizationType = .Facebook
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        self.signInFirebaseAfterProviderCredSwap(credential: credential, completion: { (user, error) in
            if error != nil {
                completion(error)
                return
            }
            
            guard let user = user else{
                completion(nil)
                return
            }
            
            fetchFbProfile(uid: user.uid, completion: { (fbFirstName, fbLastName, fbBirthday, fbFetchError) in
                self.hydateCurrentUser(user: user, completion: { (createCuError) in
                    if createCuError != nil {
                        completion(createCuError)
                    }
                    
                    if fbFetchError != nil {
                        completion(nil)
                        return
                    }
                    
                    //old first name/last name code
//                    if CurrentUser.sharedInstance.firstName == nil {
//                        CurrentUser.sharedInstance.firstName = fbFirstName
//                    }
//
//                    if CurrentUser.sharedInstance.lastName == nil {
//                        CurrentUser.sharedInstance.lastName = fbLastName
//                    }
                    
                    completion(nil)
                })
            
            })
        })
    }
    
    static func logout() {
        _authorizationType = AuthorizationType.NotSet
        fireBaseCredential = nil
        FBSDKAccessToken.setCurrent(nil)
        FBSDKLoginManager().logOut()
        FBSDKProfile.setCurrent(nil)
        GIDSignIn.sharedInstance().signOut()
        CurrentUser.sharedInstance.clearAllValues()
        let customerContext = STPCustomerContext(keyProvider: StripeService.sharedInstance)
        customerContext.clearCachedCustomer()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    static func setPermissionsFacebookBtn(_ btnFb: FBSDKLoginButton) {
        btnFb.readPermissions = fbPermissions
    }
    
    // MARK: - Private Helpers
    private static func hydateCurrentUser(user: User?, completion: @escaping (Error?) -> Swift.Void) {
        //start by zeroing out accountBalance in app
        let userInfo: [String: Any] = [notificationUserInfoKeys.accountBalance: 0]
        NotificationUtility.notifyAccountBalanceChange(userInfo: userInfo)
        
        guard let user = user else {
            completion(AuthError.userDoesNotExist)
            return
        }
        
        CurrentUser.sharedInstance.uid = user.uid //Firebase uid
        //use Firebase claims
        CurrentUser.sharedInstance.email = user.email
        CurrentUser.sharedInstance.displayName = user.displayName
        
        UserService.sharedInstance.getUser { (userModel, error) in
            if error != nil {
                completion(error)
                return
            }
            
            guard let userModel = userModel else {
                completion(AuthError.userDoesNotExist)
                return
            }
        
            CurrentUser.sharedInstance.accountBalance = userModel.accountBalance
            
            completion(nil)
        }
    }
    
    private static func signInFirebaseAfterProviderCredSwap(credential: AuthCredential, completion: @escaping (User?, Error?) -> Swift.Void) {
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            // ...
            if error != nil {
                completion(nil, error)
                return
            }
            self.fireBaseCredential = credential
            completion(authResult?.user, nil)
        }
    }
    
    private static func fetchFbProfile(uid: String, completion: @escaping (String?, String?, String?, Error?) -> Swift.Void)
    {
        if FBSDKAccessToken.current() == nil {
            completion(nil, nil, nil, nil)
            return
        }
        
        //login successfull, now request the fields we like to have in this case first name and last name
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : fbFields]).start() {
            (connection, result, error) in
            //if we have an error display it and abort
            if let error = error {
                print(error.localizedDescription)
                completion(nil, nil, nil, error)
                return
            }
            
            //parse the fields out of the result
            guard let fields = result as? [String:Any] else {
                completion(nil, nil, nil, nil)
                return
            }
            
            completion(fields[FacebookPermission.FIRST_NAME] as? String, fields[FacebookPermission.LAST_NAME] as? String, fields[FacebookPermission.BIRTHDAY] as? String, nil)
        }
    }
}
