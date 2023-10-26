//
//  UserDefaults.swift
//  GMDExtensions
//
//  Created by jung on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import Entity

public final class UserDefaultsManager {
	public static let shared = UserDefaultsManager()
	private let userDefaults = UserDefaults.standard
	
	public func removeAllData() {
		removeUser()
		removeDogs()
	}
	
	public func removeUser() {
		UserDefaults.standard.removeObject(forKey: "User")
	}
	
	public func removeDogs() {
		UserDefaults.standard.removeObject(forKey: "Dogs")
	}
	
	public func setUser(user: User) {
		if let encodedUser = try? JSONEncoder().encode(user) {
			userDefaults.setValue(encodedUser, forKey: "User")
		}
	}
	
	public func getUser() -> User? {
		guard
			let savedData = UserDefaults.standard.object(forKey: "User") as? Data,
			let user = try? JSONDecoder().decode(User.self, from: savedData) else {
			return nil
		}
		
		return user
	}
	
	public func initDogs(dog: Dog) {
		if let encodedDogs = try? JSONEncoder().encode([dog]) {
			userDefaults.setValue(encodedDogs, forKey: "Dogs")
		}
	}
	
	public func setDogs(dog: Dog) {
		var dogs = getDogs() ?? []
		
		dogs.append(dog)
		
		if let encodedDogs = try? JSONEncoder().encode(dogs) {
			userDefaults.setValue(encodedDogs, forKey: "Dogs")
		}
	}
	
	public func updateDogs(dog: Dog) {
		let dogs = getDogs() ?? []
		
		var newDogs = [Dog]()
		
		dogs.forEach { nowDog in
			if dog.id == nowDog.id {
				newDogs.append(dog)
			} else {
				newDogs.append(nowDog)
			}
		}
		
		if let encodedDogs = try? JSONEncoder().encode(newDogs) {
			userDefaults.setValue(encodedDogs, forKey: "Dogs")
		}
	}
	
	public func getDogs() -> [Dog]? {
		guard
			let data = UserDefaults.standard.object(forKey: "Dogs") as? Data,
			let dogs = try? JSONDecoder().decode([Dog].self, from: data) else {
			return nil
		}
			
		return dogs
	}
}

public struct DogStroage {
	private static var id: Int = 0
	
	public static var dogName: String = ""
	public static var dogAge: String = "4"
	public static var dogWeight: String = ""
	public static var dogImage: Data?
	public static var dogBreed: String = ""
	public static var dogCharacter = ""
	public static var dogSex: Sex = .male
	public static var dogNNN: Neutered = .true
	
	public static func getID() -> Int {
		id += 1
		return id
	}
}
