//
//  ImageLoader.swift
//  GMDExtensions
//
//  Created by 김영균 on 12/3/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum ImageLoaderError: Error {
	case unsupportedURL
	case taskNotFound
	case nodata
}

public final class ImageLoader {
	public static let shared: ImageLoader = .init()
	
	private let session: URLSession = .init(configuration: .default)
	private let cache: GaeManDaCache
	private var tasks: [AnyHashable: Task<Data, Error>] = [:]
	private let taskQueue = DispatchQueue(label: "com.gaemanda.imageloader")
	
	private init() {
		cache = Cache(cache: .init(), fileManager: .default)
		// 캐시 개수 제한
		cache.setCountLimit(100)
	}
}

extension ImageLoader {
	private func imageDownLoadTask<T: Hashable>(taskKey: T, urlString: String) -> Task<Data, Error> {
		// URL이 유효한지 확인합니다.
		guard let url = URL(string: urlString), url.scheme != nil else {
			return .detached { throw ImageLoaderError.unsupportedURL }
		}
		
		let task = Task {
			var urlRequest = URLRequest(url: url)
			urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
			urlRequest.httpMethod = "GET"
			let (data, response) = try await session.data(for: urlRequest)
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				throw ImageLoaderError.nodata
			}
			return data
		}
		
		taskQueue.sync {
			tasks[taskKey] = task
		}
		return task
	}
	
	/// 이미지를 간단한 캐싱 방법으로 가져옵니다.(이미지URL로 메모리 및 디스크 캐싱합니다.)
	///
	///  UIImageView를 확장하여 사용할 수 있습니다.
	///  ```swift
	///  extension UIImageView {
	///  @MainActor
	///  func loadImage(urlString: String) {
	///	  Task {
	///	    guard let data = await ImageLoader.shared.downloadImage(taskKey: self,  urlString: urlString) else { return }
	///	    self.image = UIImage(data: data)
	///	  }
	/// }
	/// ```
	///
	/// - Parameters:
	///   - taskKey: task를 저장할 키 값입니다. 	`Hashable` 해야합니다.
	///   - urlString: 이미지의 주소입니다. ex): {scheme}://{host}/path/image.jpeg
	///
	public func downloadImage<T: Hashable>(taskKey: T, urlString: String) async -> Data? {
		// /가 포함되면 파일을 저장할 수 없어 `/`를 제거하여 키 값으로 사용합니다.
		let key = urlString.replacingOccurrences(of: "/", with: "")
		
		if let memoryCachedData = cache.getMemoryCache(key: key) {
			return memoryCachedData
		}
		
		if let diskCachedData = cache.getDiskCache(key: key) {
			cache.setMemoryCache(key: key, data: diskCachedData)
			return diskCachedData
		}
		
		do {
			let fetchedData = try await imageDownLoadTask(taskKey: taskKey, urlString: urlString).value
			cache.setMemoryCache(key: key, data: fetchedData)
			cache.setDiskCache(key: key, data: fetchedData)
			return fetchedData
		} catch {
			return nil
		}
	}
	
	/// 이미지 다운로드를 취소합니다.
	/// - Parameter taskKey: 취소할 task의 키 값입니다. `Hashable` 해야합니다.
	/// - Throws: `taskKey`에 해당하는 task가 없을 경우 `ImageLoadError.taskNotFound`를 던집니다.s
	public func cancel<T: Hashable>(taskKey: T) throws {
		guard let task = tasks[taskKey] else { throw ImageLoaderError.taskNotFound }
		task.cancel()
		taskQueue.sync {
			_ = tasks.removeValue(forKey: taskKey)
		}
	}
	
	/// 이미지 다운로드를 취소합니다.
	/// - Parameter taskKey: 취소할 task의 키 값입니다. `Hashable` 해야합니다.
	public func cancelIfPossible<T: Hashable>(taskKey: T) {
		guard let task = tasks[taskKey] else { return }
		task.cancel()
		taskQueue.sync {
			_ = tasks.removeValue(forKey: taskKey)
		}
	}
}
