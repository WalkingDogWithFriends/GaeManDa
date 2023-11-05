//
//  NetworkError.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
	public enum ParameterEncodingFailureReason {
		case missingURL
		case jsonEncodingFailed(error: Error)
		case customEncodingFailed(error: Error)
		
		var localizedDescription: String {
			switch self {
			case .missingURL:
				return "URL request to encode was missing a URL"
				
			case let .jsonEncodingFailed(error):
				return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
			
			case let .customEncodingFailed(error):
				return "Custom parameter encoder failed with error: \(error.localizedDescription)"
			}
		}
	}
	
	public enum NetworkFailureReason {
		case httpNoResponse
		case clientError(errorCode: Int)
		case serverError(errorCode: Int)
		case jsonDecodingFailed
		case noData
		case noHttpURLRepsonse
		
		var localizedDescription: String {
			switch self {
			case .httpNoResponse:
				return "HTTPURLResponse optional binding failed"
			
			case .clientError(let errorCode):
				return "client error: \(errorCode)"
			
			case .serverError(let errorCode):
				return "server error: \(errorCode)"
				
			case .jsonDecodingFailed:
				return "jsonDecodingFailed"
				
			case .noData:
				return "noData"
				
			case .noHttpURLRepsonse:
				return "noHttpURLRepsonse"
			}
		}
	}
	
	case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
	case networkFailed(reason: NetworkFailureReason)
}
