//
//  KeyChainStorage.swift
//  LocalStorage
//
//  Created by 김영균 on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Security

public final class KeyChainStorage {
	public static let shared: KeyChainStorage = KeyChainStorage()
	
	public enum KeyChainError: Error {
		case noAccessToken
		case noRefreshToken
		case valueEncodingError
	}
	
	public enum KeyChainKey: String {
		case accessTokenKey
		case refreshTokenKey
		case isOnboardingFinished
	}
	
	enum OnboardingFinished: String {
		case `true`
	}
	
	private init() { }
}

public extension KeyChainStorage {
	func setUserHasOnboardingFinished() throws {
		try saveToKeychain(value: OnboardingFinished.true.rawValue, forKey: KeyChainKey.isOnboardingFinished)
	}
	
	func setAccessToken(_ token: String) throws {
		try saveToKeychain(value: token, forKey: KeyChainKey.accessTokenKey)
	}
	
	func setRefreshToken(_ token: String) throws {
		try saveToKeychain(value: token, forKey: KeyChainKey.refreshTokenKey)
	}
	
	func isOnboardingFinished() throws -> Bool {
		guard let onboardingState = try loadFromKeychain(forKey: KeyChainKey.isOnboardingFinished) else {
			return false
		}
		return onboardingState == OnboardingFinished.true.rawValue
	}
	
	@discardableResult
	func getAccessToken() throws -> String {
		guard let accessToken = try loadFromKeychain(forKey: KeyChainKey.accessTokenKey) else {
			throw KeyChainError.noAccessToken
		}
		return accessToken
	}
	
	func getRefreshToken() throws -> String {
		guard let accessToken = try loadFromKeychain(forKey: KeyChainKey.accessTokenKey) else {
			throw KeyChainError.noRefreshToken
		}
		return accessToken
	}
	
	func hasAccessToken() -> Bool {
		do {
			try getAccessToken()
			return true
		} catch {
			return false
		}
	}
	
	func clearKeyChain(forKey key: KeyChainKey) throws {
		let keychainQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.rawValue
		]
		SecItemDelete(keychainQuery as CFDictionary)
	}
}

private extension KeyChainStorage {
	func saveToKeychain(value: String, forKey key: KeyChainKey) throws {
		guard let valueData = value.data(using: .utf8) else {
			throw KeyChainError.valueEncodingError
		}
		let keychainQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.rawValue,
			kSecValueData as String: valueData
		]
		
		SecItemDelete(keychainQuery as CFDictionary)
		SecItemAdd(keychainQuery as CFDictionary, nil)
	}
	
	func loadFromKeychain(forKey key: KeyChainKey) throws -> String? {
		let keychainQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key.rawValue,
			kSecReturnData as String: kCFBooleanTrue!,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var dataTypeRef: AnyObject?
		
		let status: OSStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
		
		if status == noErr {
			if let retrievedData = dataTypeRef as? Data,
				let result = String(data: retrievedData, encoding: .utf8) {
				return result
			}
		}
		return nil
	}
}
