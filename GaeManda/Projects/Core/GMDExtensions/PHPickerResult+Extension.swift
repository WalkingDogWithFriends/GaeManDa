//
//  PHPickerResult+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/09/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import PhotosUI
import RxCocoa
import RxSwift

public extension PHPickerResult {
	func fetchImage() -> Single<UIImage> {
		return Single.create { single in
			self.fetchImage(completion: single)
			return Disposables.create()
		}
	}
	
	func fetchImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
		let provider = self.itemProvider
		if provider.canLoadObject(ofClass: UIImage.self) {
			provider.loadObject(ofClass: UIImage.self) { image, error in
				if let error = error {
					completion(.failure(error))
				}
				if let image = image as? UIImage {
					completion(.success(image))
				}
			}
		}
	}
}
