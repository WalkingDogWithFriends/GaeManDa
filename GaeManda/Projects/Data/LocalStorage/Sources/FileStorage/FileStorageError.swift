//
//  FileStorageError.swift
//  LocalStorage
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum FileStorageError: Error {
	case invalidURL
	case jsonEncodingFailed(error: Error)
	case noData(error: Error)
	
	var localizedDescription: String {
		switch self {
		case .invalidURL:
			return "invalid URL"
			
		case let .jsonEncodingFailed(error):
			return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
			
		case let .noData(error):
			return "No data because of error:\n\(error.localizedDescription)"
		}
	}
}
