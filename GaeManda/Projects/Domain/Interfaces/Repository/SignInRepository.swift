//
//  SignInRepository.swift
//  Repository
//
//  Created by jung on 2023/09/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol SignInRepository {
	func tryKakaoSignIn() async -> Bool
}
