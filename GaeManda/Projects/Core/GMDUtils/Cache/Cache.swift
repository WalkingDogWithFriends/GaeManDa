//
//  Cache.swift
//  GMDExtensions
//
//  Created by 김영균 on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public protocol MemoryCache {
	func setCountLimit(_ count: Int)
	func setMemoryCache(key: String, data: Data)
	func getMemoryCache(key: String) -> Data?
}

public protocol DiskCache {
	func setDiskCache(key: String, data: Data)
	func getDiskCache(key: String) -> Data?
}

public protocol GaeManDaCache: MemoryCache & DiskCache { }

public final class Cache: GaeManDaCache {
	private let cache: NSCache<NSString, NSData>
	private let fileManager: FileManager
	private let cacheQueue = DispatchQueue(label: "com.gaemanda.cache")
	
	init(cache: NSCache<NSString, NSData>, fileManager: FileManager) {
		self.cache = cache
		self.fileManager = fileManager
	}
}

public extension Cache {
	func setCountLimit(_ count: Int) {
		cache.countLimit = count
	}
	
	func setMemoryCache(key: String, data: Data) {
		cacheQueue.sync {
			cache.setObject(data as NSData, forKey: key as NSString)
		}
	}
	
	func getMemoryCache(key: String) -> Data? {
		return cache.object(forKey: key as NSString) as? Data
	}
}

public extension Cache {
	func setDiskCache(key: String, data: Data) {
		guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
		let fileURL = cacheDirectory.appendingPathComponent(key)
		try? data.write(to: fileURL)
	}
	
	func getDiskCache(key: String) -> Data? {
		guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
		let fileURL = cacheDirectory.appendingPathComponent(key)
		return try? Data(contentsOf: fileURL)
	}
}
