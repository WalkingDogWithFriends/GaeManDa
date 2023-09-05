//
//  DogsCarouselViewModel.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

struct DogsCarouselViewModel {
	var dogs: [Dog] = []
	
	/// 강아지의 원래 갯수
	var dogsCount: Int {
		dogs.isEmpty ? 0 : dogs.count - 2
	}
}
