//

import Foundation

protocol Network {
    func get<Resource: Decodable>(path: String) async throws -> Resource 
}

class ConcreteJSONBasedNetwork: Network {
    
    private let session: URLSession
    private let baseUrl: URL
    private let jsonDecoder: JSONDecoder
    
    init(session: URLSession = .shared, jsonDecoder: JSONDecoder, baseUrl: URL) {
        self.session = session
        self.baseUrl = baseUrl
        self.jsonDecoder = jsonDecoder
    }
    
    func get<Resource: Decodable>(path: String) async throws -> Resource {
        let (data, _) = try await session.data(for: request(path: path, method: .get))
        return try jsonDecoder.decode(Resource.self, from: data)
    }
    
    private func request(path: String, method: HttpVerb) -> URLRequest {
        let url = URL(string: path, relativeTo: baseUrl)!
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue.uppercased()
        return req
    }
    
    enum HttpVerb: String {
        case get
        // etc..
    }
}
