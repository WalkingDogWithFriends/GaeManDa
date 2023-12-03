//
//  GeocodeAPI.swift
//  DTO
//
//  Created by 김영균 on 10/31/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import GMDNetwork

public enum GeocodeAPI {
	case fetchGeocode(query: String)
}

extension GeocodeAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "https://naveropenapi.apigw.ntruss.com")!
	}
	
	public var path: String {
		return "/map-geocode/v2/geocode"
	}
	
	public var method: HTTPMethod {
		return .get
	}
	
	public var task: TaskType {
		switch self {
		case .fetchGeocode(query: let query):
			return .requestParameters(parameters: ["query": query], encoding: .queryString)
		}
	}
	
	public var headers: HTTPHeaders {
		guard
			let plist = Bundle.main.infoDictionary,
			let clientId = plist["NMFClientId"] as? String,
			let clientScret = plist["NMFClientSecret"] as? String
		else {
			return .default
		}
		return HTTPHeaders([
			HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: clientId),
			HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: clientScret)
		])
	}
	
	public var sampleData: Data {
		return Data()
	}
}
