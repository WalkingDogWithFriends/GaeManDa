//
//  TaskType.swift
//  DTO
//
//  Created by 김영균 on 2023/07/02.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum TaskType {
	/// A request with no additional data.
	case requestPlain
	/// A request body set with `Encodable` type
	case requestJSONEncodable(Encodable)
	/// A request body set with `Encodable` type and custom encoder
	case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
	/// get의 query string 또는 post의 body에 값을 넣을 때 사용합니다.
	case requestParameters(parameters: [String: Any], encoding: EncodingType)
	/// A requests body set with encoded parameters combined with url parameters.
	case requestCompositeParameters(urlParameters: [String: Any], bodyParameters: [String: Any])
	/// A "multipart/form-data" upload task.
	case uploadMultipart(parameters: [String: Any])
}
