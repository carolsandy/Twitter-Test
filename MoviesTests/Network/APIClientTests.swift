
import XCTest

@testable import Movies

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        sut = APIClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_SearchMovie_UsesExpectedHost() {
        let completion = { (movies: Movies?, error: Error?) in }
        sut.getMovies(with: "Kill Bill", completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.host, "api.themoviedb.org")
    }
    
    func test_SearchMovie_UsesExpectedPath() {
        let completion = { (movies: Movies?, error: Error?) in }
        sut.getMovies(with: "Kill Bill", completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/3/search/movie")
    }
    
    func test_SearchMovie_UsesExpectedQuery() {
        let completion = { (movies: Movies?, error: Error?) in }
        sut.getMovies(with: "Kill Bill", completion: completion)
        XCTAssertEqual(mockURLSession.urlComponents?.percentEncodedQuery, "api_key=2a61185ef6a27f400fd92820ad9e8537&query=Kill%20Bill")
    }
    
    func test_SearchMovie_WhenSuccessful_CreatesMovies() {
        mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let moviesExpectation = expectation(description: "Movies")
        var caughtMovies: Movies? = nil
        sut.getMovies(with: "Kill Bill") { (movies, error) in
            caughtMovies = movies
            moviesExpectation.fulfill()
        }
        waitForExpectations(timeout: 4) { _ in
            XCTAssertEqual(caughtMovies?.count, 2)
            XCTAssertEqual(caughtMovies?.movies[0].title, "Kill Bill: Vol. 1")
            XCTAssertEqual(caughtMovies?.movies[0].overview, "An assassin is shot by her ruthless employer, Bill, and other members of their assassination circle – but she lives to plot her vengeance.")
            XCTAssertEqual(caughtMovies?.movies[0].posterPath, "/v7TaX8kXMXs5yFFGR41guUDNcnB.jpg")
        }
    }
    
    func test_SearchMovie_WhenJSONIsInvalid_ReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.getMovies(with: "Kill Bill") { (movies, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 4) { _ in
            XCTAssertNotNil(catchedError)
        }
    }
    
    func test_SearchMovie_WhenResponseHasError_ReturnsError() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: error)
        sut.session = mockURLSession
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.getMovies(with: "Kill Bill") { (movies, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 4) { _ in
            XCTAssertNotNil(catchedError)
        }
    }
    
}

extension APIClientTests {
    class MockURLSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask
        
        var urlComponents: URLComponents? {
            guard let url = url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, response: urlResponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let URLresponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.URLresponse = response
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async() {
                self.completionHandler?(self.data, self.URLresponse, self.responseError)
            }
        }
    }
}

let jsonData = """
{
    "page": 1,
    "total_results": 2,
    "total_pages": 1,
    "results": [
        {
            "popularity": 37.388,
            "vote_count": 11145,
            "video": false,
            "poster_path": "/v7TaX8kXMXs5yFFGR41guUDNcnB.jpg",
            "id": 24,
            "adult": false,
            "backdrop_path": "/kkS8PKa8c134vXsj2fQkNqOaCXU.jpg",
            "original_language": "en",
            "original_title": "Kill Bill: Vol. 1",
            "genre_ids": [
                28,
                80
            ],
            "title": "Kill Bill: Vol. 1",
            "vote_average": 8,
            "overview": "An assassin is shot by her ruthless employer, Bill, and other members of their assassination circle – but she lives to plot her vengeance.",
            "release_date": "2003-10-10"
        },
        {
            "popularity": 25.198,
            "vote_count": 8908,
            "video": false,
            "poster_path": "/2yhg0mZQMhDyvUQ4rG1IZ4oIA8L.jpg",
            "id": 393,
            "adult": false,
            "backdrop_path": "/70EtzaGfO2d8X5n8SLI4s61KuJh.jpg",
            "original_language": "en",
            "original_title": "Kill Bill: Vol. 2",
            "genre_ids": [
                28,
                80,
                53
            ],
            "title": "Kill Bill: Vol. 2",
            "vote_average": 7.9,
            "overview": "The Bride unwaveringly continues on her roaring rampage of revenge against the band of assassins who had tried to kill her and her unborn child. She visits each of her former associates one-by-one, checking off the victims on her Death List Five until there's nothing left to do … but kill Bill.",
            "release_date": "2004-04-16"
        }
    ]
}
""".data(using: .utf8)
