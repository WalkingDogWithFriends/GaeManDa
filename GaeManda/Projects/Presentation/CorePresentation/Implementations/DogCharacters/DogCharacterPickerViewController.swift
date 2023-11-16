//
//  DogCharacterPickerViewController.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs

protocol DogCharacterPickerPresentableListener: AnyObject { }

final class DogCharacterPickerViewController:
	UIViewController,
	DogCharacterPickerPresentable,
	DogCharacterPickerViewControllable {
	weak var listener: DogCharacterPickerPresentableListener?
}
