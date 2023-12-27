//
//  DogProfileSecondDashboardInteractor.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogProfileSecondDashboardRouting: ViewableRouting { }

protocol DogProfileSecondDashboardPresentable: Presentable {
	var listener: DogProfileSecondDashboardPresentableListener? { get set }
	
	func updateDogSpecies(_ dogSpecies: [String], selectedDogSpecies: String?)
}

final class DogProfileSecondDashboardInteractor:
	PresentableInteractor<DogProfileSecondDashboardPresentable>,
	DogProfileSecondDashboardInteractable {
	weak var router: DogProfileSecondDashboardRouting?
	weak var listener: DogProfileSecondDashboardListener?
	
	private let dogSepecies: [String]
	private var selectedDogSpecies: String?

	init(
		presenter: DogProfileSecondDashboardPresentable,
		dogSpecies: [String],
		selectedDogSpecies: String?
	) {
		self.dogSepecies = dogSpecies
		self.selectedDogSpecies = selectedDogSpecies
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - DogProfileSecondDashboardPresentableListener
extension DogProfileSecondDashboardInteractor: DogProfileSecondDashboardPresentableListener {
	func viewDidLoad() {
		presenter.updateDogSpecies(dogSepecies, selectedDogSpecies: selectedDogSpecies)
	}
	
	func didSelectedDogSpecies(_ dogSpecies: String) {
		listener?.didSelectedDogSpecies(dogSpecies)
	}
	
	func didSelectedIsNeutered(_ isNeutered: Bool) {
		listener?.didSelectedIsNeutered(isNeutered)
	}
}
