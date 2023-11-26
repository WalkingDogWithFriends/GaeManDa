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
	
	public func fetchDogs() -> Single<[Dog]> {
		return  Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.fetchDogs, type: [FetchDogsResponseDTO].self)
			.map { $0.map { dogDataMapper.mapToDog(from: $0) } }
	}
	
	public func updateDog(_ dog: Dog, isProfileImageChanged: Bool) -> Single<Void> {
		let resquestDTO = dogDataMapper.mapToUpdateDogRequestDTO(from: dog, isProfileImageChaged: isProfileImageChanged)
		
		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.updateDog(resquestDTO), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func createDog(_ dog: Dog) -> Single<Void> {
		let resquestDTO = dogDataMapper.mapToCreateDogRequestDTO(from: dog)

		return Provider<DogAPI>
			.init(stubBehavior: .immediate)
			.request(DogAPI.createDog(resquestDTO), type: VoidResponse.self)
			.map { _ in }
	}
	
	public func fetchDogCharacters() -> Single<[DogCharacter]> {
		return Single.create { single in
			let result = FileProvider<DogFileAPI>()
				.request(DogFileAPI.fetchCharacters, type: [DogCharacterResponseDTO].self)
				.map { dogDataMapper.mapToDogCharacter(from: $0) }
			
			switch result {
				case .success(let characters): single(.success(characters))
				case .failure(let error): single(.failure(error))
			}
			
			return Disposables.create()
		}
	}
	
	public func fetchDogSpecies() -> Single<[String]> {
		return Single.create { single in
			let result = FileProvider<DogFileAPI>()
				.request(DogFileAPI.fetchSpecies, type: [DogSpeciesResponseDTO].self)
				.map { $0.map { $0.species } }
			
			switch result {
				case .success(let species): single(.success(species))
				case .failure(let error): single(.failure(error))
			}
			
			return Disposables.create()
		}
	}
}
