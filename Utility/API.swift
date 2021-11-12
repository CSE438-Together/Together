//
//  APIFunction.swift
//  Together
//
//  Created by Moran Xu on 10/29/21.
//

import Foundation
import Amplify

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

}
