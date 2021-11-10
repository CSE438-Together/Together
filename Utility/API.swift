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
        Amplify.DataStore.query(Post.self) {
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
//
//    static func createPost() {
//        let time = Date()
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .medium
//        let timeString = formatter.string(from: time)
//
//        let postTest = Post(author: "Hive", departureTime: timeString, source: "Kingsbury", destination: "WashU", transportation: "On Foot2", description: "Go to blow up the school", maxMembers: i, title: "Let's go to place \(i)", postTime: timeString)
//        let postTest = Post()
//
//        Amplify.DataStore.save(postTest) { result in
//            switch result {
//            case .success:
//                print("Post saved successfully!")
//            case .failure(let error):
//                print("Error saving post \(error)")
//            }
//        }
//    }
    
//    static func loadPosts() -> [Post] {
//        var posts : [Post] = []
//        Amplify.DataStore.query(Post.self){
//            switch $0 {
//            case .success(let result):
//                // result will be of type [Post]
//                posts = result
//            case .failure(let error):
//                print("Error on query() for type Post - \(error.localizedDescription)")
//            }
//        }
//        return posts
//    }
}
