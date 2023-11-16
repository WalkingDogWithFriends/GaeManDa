//
//  DogCharacterPicker.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol DogCharacterPickerBuildable: Buildable {
		func build(withListener listener: DogCharacterPickerListener) -> ViewableRouting
}

public protocol DogCharacterPickerListener: AnyObject { }
