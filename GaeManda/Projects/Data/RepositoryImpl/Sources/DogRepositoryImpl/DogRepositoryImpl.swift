//
//  DogRepositoryImpl.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RxSwift
import DataMapper
import DTO
import Entity
import GMDNetwork
import LocalStorage
import Repository

public struct DogRepositoryImpl: DogRepository {
	private let dogDataMapper: DogDataMapper
	
	public init(dogDataMapper: DogDataMapper) {
		self.dogDataMapper = dogDataMapper
	}
	
	public func fetchDogs(id: Int) -> Single<[Dog]> {
		return  Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.fetchDogs(id: id), type: [DogResponseDTO].self)
			.map { $0.map { dogDataMapper.mapToDog(from: $0) } }
	}
	
	public func updateDog(dog: Dog) -> Single<Void> {
		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.updateDogs(dog: dog), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func postNewDog(dog: Dog) -> Single<Void> {
		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.postNewDog(dog: dog), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func fetchDogCharacters() -> Single<[DogCharacter]> {
		return Single.create { single in
			let result = FileProvider<OnboardingFileAPI>()
				.request(DogFileAPI.fetchCharacters, type: [DogCharacterResponseDTO].self)
				.map { dogDataMapper.mapToDogCharacter(from: $0) }
			
			switch result {
				case .success(let characters): single(.success(characters))
				case .failure(let error): single(.failure(error))
			}
			
			return Disposables.create()
		}
	}
}
