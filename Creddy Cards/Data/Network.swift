//

import Foundation

/// the (beginnings of) a Network abstraction
protocol Network {
    func get<Resource: Decodable>(path: String) async throws -> Resource
    // etc...
}

/// a customizable network class, that allows the consumer to customize the base url, and jsonDecoder
class ConcreteJSONBasedNetwork: Network {
    
    private let session: URLSession
    private let baseUrl: URL
    private let jsonDecoder: JSONDecoder
    
    init(session: URLSession = .shared, jsonDecoder: JSONDecoder, baseUrl: URL) {
        self.session = session
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
    }
    
    private func request(path: String, method: HttpVerb) -> URLRequest {
        let url = URL(string: path, relativeTo: baseUrl)!
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue.uppercased()
        return req
    }
    
    func get<Resource>(path: String) async throws -> Resource where Resource : Decodable {
        let (data, _) = try await session.data(for: request(path: path, method: .get))
        return try jsonDecoder.decode(Resource.self, from: data)
    }
    
    enum HttpVerb: String {
        case get
        // etc..
    }
}

#if DEBUG
class StubbedNetwork<ExpectedResource: Decodable> {
    
    typealias Resource = ExpectedResource
    
    let resource: Resource
    
    init(expectedResource: Resource) {
        self.resource = expectedResource
    }
}

extension StubbedNetwork: Network {
    
    func get<Resource>(path: String) async throws -> Resource {
        resource as! Resource
    }
    
}

#endif
