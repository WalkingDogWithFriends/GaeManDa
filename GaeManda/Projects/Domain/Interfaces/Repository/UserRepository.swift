//
//  UserRepository.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Entity

public protocol UserRepository {
	func fetchUser(id: Int) async -> Single<User>
}
