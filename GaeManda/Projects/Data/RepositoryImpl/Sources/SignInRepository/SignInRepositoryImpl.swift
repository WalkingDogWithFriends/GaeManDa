//
//  SignInRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/09/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift
import DTO
import GMDNetwork
import Repository

public struct SignInRepositoryImpl: SignInRepository {
	public init() { }

	public func tryKakaoSignIn() -> Observable<Bool> {
		// 유저가 KakaoTalk이 있는 경우
		if UserApi.isKakaoTalkLoginAvailable() {
			return UserApi.shared.rx.loginWithKakaoTalk()
				.flatMap { tryKakaoSignIn(with: $0.accessToken) }
		// 유저가 KakaoTalk이 없는 경우
		} else {
			return UserApi.shared.rx.loginWithKakaoAccount()
				.flatMap { tryKakaoSignIn(with: $0.accessToken) }
		}
	}
}

// MARK: - Login Extension
private extension SignInRepositoryImpl {
	/// Kakao Login
	func tryKakaoSignIn(with accessToken: String) -> Observable<Bool> {
		return Provider<SignInAPI>
			.init(stubBehavior: .immediate)
			.request(SignInAPI.tryKakaoSignIn(token: accessToken), type: SignInResponseDTO.self)
			.asObservable()
			.map { $0.userDidSignIn }
	}
}
