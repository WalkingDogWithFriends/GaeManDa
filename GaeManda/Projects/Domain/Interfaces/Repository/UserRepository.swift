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
	func fetchUser() -> Single<User>
	func updateUser(_ user: User, isProfileImageChanged: Bool) -> Single<Void>
	func createUser(_ user: User) -> Single<Void>
	func checkDuplicated(nickName: String) -> Single<Void>
}
