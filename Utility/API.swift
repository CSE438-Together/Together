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
            switch $0 {
            case .success(let items):
                posts = items
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
        return posts
    }
    
    public static func signIn(_ email: String, _ password: String, completion: @escaping ((Result<Never, AuthError>) -> Void)) {
        DispatchQueue.global().async {
            Amplify.Auth.signIn(username: email, password: password) {
                switch $0 {
                case .success:
                    DispatchQueue.main.async {
                        UIApplication.shared.windows.first?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
