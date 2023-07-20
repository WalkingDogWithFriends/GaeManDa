//
//  DogReposiotry.swift
//  Repository
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity
import RxSwift

public protocol DogRepository {
	func fetchDogs(id: Int) async -> Single<[Dog]>
}
