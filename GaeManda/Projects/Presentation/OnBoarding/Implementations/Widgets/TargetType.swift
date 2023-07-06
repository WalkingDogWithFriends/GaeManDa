import Foundation

public protocol TargetType: URLReqeustConvertible {
	var baseURL: URL { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var task: TaskType { get }
	var headers: HTTPHeaders { get }
	var sampleData: Data { get }
}

public extension TargetType {
	func asURLRequest() throws -> URLRequest {
		var urlReqeust = URLRequest(url: baseURL.appendingPathComponent(path))
		
		urlReqeust.httpMethod = method.rawValue
		urlReqeust.allHTTPHeaderFields = headers.dictionary
		urlReqeust = try addParameter(to: urlReqeust)
		
		return urlReqeust
	}
	
	func addParameter(to request: URLRequest) throws -> URLRequest {
		var request = request
		
		switch task {
		case .requestPlain:
			break
			
		case let .requestJSONEncodable(parameters):
			request.httpBody = try JSONEncoder().encode(parameters)
			
		case let .requestCustomJSONEncodable(parameters, encoder):
			request.httpBody = try encoder.encode(parameters)
			
		case let .requestParameters(parameters, encoding):
			request = try encoding.encode(request, with: parameters)
			
		case let .reqeustCompositeParameter(query, body):
			request = try EncodingType.queryString.encode(request, with: query)
			request = try EncodingType.jsonBody.encode(request, with: body)
		}
		
		return request
	}
}
