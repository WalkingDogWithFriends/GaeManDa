//
//  DogCharacterDashboard.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import Entity

public protocol DogCharacterDashboardBuildable: Buildable {
	func build(
		withListener listener: DogCharacterDashboardListener,
		selectedCharacters: BehaviorRelay<[DogCharacter]>
	) -> ViewableRouting
}

public protocol DogCharacterDashboardListener: AnyObject { 
	func didTapAddCharacterButton()
}
