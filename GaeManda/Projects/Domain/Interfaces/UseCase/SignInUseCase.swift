//
//  SignInUseCase.swift
//  UseCase
//
//  Created by jung on 2023/09/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import Repository

public protocol SignInUseCase {
	var dependency: SignInRepository { get }
	
	init(dependency: SignInRepository)
	
	func tryKakaoSignIn() -> Observable<Bool>
}
