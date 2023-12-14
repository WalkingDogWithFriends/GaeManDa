//
//  SignInRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/09/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import DTO
import GMDNetwork
import LocalStorage
import Repository

public struct SignInRepositoryImpl {
	private let keychainStorage: KeyChainStorage
	
	public init(keychainStorage: KeyChainStorage) {
		self.keychainStorage = keychainStorage
	}
}

extension SignInRepositoryImpl: SignInRepository {
	public func tryKakaoSignIn() async -> Bool {
		do {
			let kakaoToken = try await tryAuthentication()
			let localToken = try await saveAuthorization(kakaoToken.accessToken)
			try saveToken(accessToken: localToken.accessToken, refreshToken: localToken.refreshToken)
			return true
		} catch {
			return false
		}
	}
	
	public func isOnboardingFinished() -> Bool {
		do {
			return try keychainStorage.isOnboardingFinished()
		} catch {
			return false
		}
	}
	
	public func isAuthorized() -> Bool {
		return keychainStorage.hasAccessToken()
	}
}

// MARK: - Login Extension
private extension SignInRepositoryImpl {
	func saveAuthorization(_ accessToken: String) async throws -> SignInResponseDTO {
		return try await Provider<SignInAPI>
			.init()
			.request(SignInAPI.tryKakaoSignIn(token: accessToken), type: SignInResponseDTO.self)
	}
	
	@MainActor
	func tryAuthentication() async throws -> SignInResponseDTO {
		if UserApi.isKakaoTalkLoginAvailable() {
			return try await withCheckedThrowingContinuation { continuation in
				UserApi.shared.loginWithKakaoTalk { token, error in
					handleKakaoLoginResponse(token: token, error: error, with: continuation)
				}
			}
		} else {
			return try await withCheckedThrowingContinuation { continuation in
				UserApi.shared.loginWithKakaoAccount { token, error in
					handleKakaoLoginResponse(token: token, error: error, with: continuation)
				}
			}
		}
	}
	
	func saveToken(accessToken: String, refreshToken: String) throws {
		try keychainStorage.setAccessToken(accessToken)
		try keychainStorage.setRefreshToken(refreshToken)
	}
	
	func handleKakaoLoginResponse(
		token: OAuthToken?,
		error: Error?,
		with continuation: CheckedContinuation<SignInResponseDTO, Error>
	) {
		if let error = error {
			continuation.resume(throwing: error)
			return
		}
		
		if let token = token {
			continuation.resume(
				returning: SignInResponseDTO(
					accessToken: token.accessToken,
					refreshToken: token.refreshToken
				)
			)
			return
		}
	}
}
