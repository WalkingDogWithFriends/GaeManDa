//
//  TermsofUseUseCase.swift
//  Repository
//
//  Created by 김영균 on 11/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxSwift
import Entity

public protocol TermsofUseUseCase {
	func fetchTerms() -> Single<Terms>
}
