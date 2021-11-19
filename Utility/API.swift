//
//  APIFunction.swift
//  Together
//
//  Created by Moran Xu on 10/29/21.
//

import Foundation
import Amplify
import UIKit
import SwiftUI

class API {
    public static func getAll(where: QueryPredicate? = nil, sort: QuerySortInput? = nil) -> [Post] {
        var posts: [Post] = []
        Amplify.DataStore.query(Post.self, where: `where`, sort: sort) {
            result in
            switch(result) {
            case .success(let items):
                posts = items
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return posts
    }

    public static func signIn(_ email: String, _ password: String, completion: (() -> Void)? = nil, _ handleFailure: ((String) -> Void)? = nil) {
        DispatchQueue.global().async {
            Amplify.Auth.signIn(username: email, password: password) {
                result in
                switch result {
                case .success:
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    DispatchQueue.main.async {                        
                        let controller = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        UIApplication.shared.windows.first?.rootViewController = controller
                    }
                case .failure(let error):
                    if let handler = handleFailure {
                        handler(error.errorDescription)
                    }
                }
            }
            DispatchQueue.main.async {
                if let handler = completion {
                    handler()
                }
            }
        }
    }
}
