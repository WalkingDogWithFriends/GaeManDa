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
	
	enum KeychainError: Error {
		case noAccessToken
		case noRefreshToken
		case valueEncodingError
	}
	
	enum KeyChanKey {
		static let accessTokenKey = "accessTokenKey"
		static let refreshTokenKey = "refreshTokenKey"
	}
	
	private init() { }
}

public extension KeyChainStorage {
	func setAccessToken(_ token: String) throws {
		try saveToKeychain(value: token, forKey: KeyChanKey.accessTokenKey)
	}
	
	func setRefreshToken(_ token: String) throws {
		try saveToKeychain(value: token, forKey: KeyChanKey.refreshTokenKey)
	}
	
	func getAccessToken() throws -> String {
		guard let accessToken = try loadFromKeychain(forKey: KeyChanKey.accessTokenKey) else {
			throw KeychainError.noAccessToken
		}
		return accessToken
	}
	
	func getRefreshToken() throws -> String {
		guard let accessToken = try loadFromKeychain(forKey: KeyChanKey.accessTokenKey) else {
			throw KeychainError.noRefreshToken
		}
		return accessToken
	}
}

private extension KeyChainStorage {
	func saveToKeychain(value: String, forKey key: String) throws {
		guard let valueData = value.data(using: .utf8) else {
			throw KeychainError.valueEncodingError
		}
		let keychainQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecValueData as String: valueData
		]
		
		SecItemDelete(keychainQuery as CFDictionary)
		SecItemAdd(keychainQuery as CFDictionary, nil)
	}
	
	func loadFromKeychain(forKey key: String) throws -> String? {
		let keychainQuery: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: key,
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
