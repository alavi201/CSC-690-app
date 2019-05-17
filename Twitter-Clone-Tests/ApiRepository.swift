import Foundation
class Post: Codable {
    let text: String
    let username: String
}
class APIRepository {
    var session: URLSession!
    func getPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8081/getFollowedPosts")
            else { fatalError() }
        session.dataTask(with: url) { (_, _, _) in }
    }
}
