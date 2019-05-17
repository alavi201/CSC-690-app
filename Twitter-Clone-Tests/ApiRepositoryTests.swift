import XCTest
@testable import Twitter_Clone
class APIRepositoryTests: XCTestCase {
    func testGetPostsWithExpectedURLHostAndPath() {
        let apiRespository = APIRepository()
        let mockURLSession  = MockURLSession()
        apiRespository.session = mockURLSession
        apiRespository.getPosts(completion: ) { movies, error in  }
        XCTAssertEqual(mockURLSession.cachedUrl?.host, "127.0.0.1")
        XCTAssertEqual(mockURLSession.cachedUrl?.path, "/getFollowedPosts")
    }
}
class MockURLSession: URLSession {
    var cachedUrl: URL?
    override func dataTask(with url: URL, completionHandler:      @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedUrl = url
        return URLSessionDataTask()
    }
}
