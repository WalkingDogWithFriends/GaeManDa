//
//  DogProfileSecondDashboardViewController.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit

// swiftlint:disable:next type_name
protocol DogProfileSecondDashboardPresentableListener: AnyObject { 
	func viewDidLoad()
	func didSelectedDogSpecies(_ dogSpecies: String)
	func didSelectedIsNeutered(_ isNeutered: Bool)
}

final class DogProfileSecondDashboardViewController:
	UIViewController,
	DogProfileSecondDashboardViewControllable {
	// MARK: - Properties
	weak var listener: DogProfileSecondDashboardPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private lazy var dogSpeciesDropDownButton = DropDownButton(text: "우리 아이 종", mode: .title)
	private lazy var dogSpeciesDropDownView = DropDownView(anchorView: dogSpeciesDropDownButton)
		
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let didNeuterButton = GMDOptionButton(title: "중성화 했어요", isSelected: true)
	private let didNotNeuterButton = GMDOptionButton(title: "중성화 안 했어요")

	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		dogSpeciesDropDownView.delegate = self
		setupUI()
		listener?.viewDidLoad()
	}
}

// MARK: - UI Methods
private extension DogProfileSecondDashboardViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(dogSpeciesDropDownView, buttonStackView)
		buttonStackView.addArrangedSubviews(didNeuterButton, didNotNeuterButton)
	}
	
	func setConstraints() {
		dogSpeciesDropDownView.snp.makeConstraints { make in
			make.leading.top.trailing.equalToSuperview()
		}
		
		dogSpeciesDropDownView.setConstraints { [weak self] make in
			guard let self else { return }
			make.leading.trailing.equalTo(self.dogSpeciesDropDownButton)
			make.top.equalTo(self.dogSpeciesDropDownButton.snp.bottom)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(dogSpeciesDropDownView.snp.bottom).offset(32)
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(40)
		}
	}
}

// MARK: - UI Binding
private extension DogProfileSecondDashboardViewController {
	func bind() {
		bindDropDown()
		bindButtons()
	}
	
	private func bindDropDown() {
		dogSpeciesDropDownView.rx.selectedOption
			.map { ($0, .option) }
			.bind(to: dogSpeciesDropDownButton.rx.title)
			.disposed(by: disposeBag)
	}
	
	private func bindButtons() {
		// 중성화 버튼 선택 Observable
		let selectedNeuteredObservable = Observable
			.merge(
				didNeuterButton.rx.tap.map { true },
				didNotNeuterButton.rx.tap.map { false }
			)
			.asDriver(onErrorJustReturn: true)
		
		selectedNeuteredObservable
			.distinctUntilChanged()
			.drive(with: self) { owner, isNeutered in
				owner.listener?.didSelectedIsNeutered(isNeutered)
			}
			.disposed(by: disposeBag)
		
		// 중성화 한 경우
		selectedNeuteredObservable
			.map { $0 }
			.drive(didNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 중성화 안한 경우
		selectedNeuteredObservable
			.map { !$0 }
			.drive(didNotNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
}

// MARK: - DogProfileSecondDashboardPresentable
extension DogProfileSecondDashboardViewController: DogProfileSecondDashboardPresentable {
	func updateDogSpecies(_ dogSpecies: [String], selectedDogSpecies: String?) {
		dogSpeciesDropDownView.dataSource = dogSpecies
		
		guard let selectedDogSpecies = selectedDogSpecies else { return }
		
		dogSpeciesDropDownButton.setTitle(selectedDogSpecies, for: .option)
		dogSpeciesDropDownView.defaultSelectedOption = selectedDogSpecies
	}
}

// MARK: - DropDownListener
extension DogProfileSecondDashboardViewController: DropDownDelegate {
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath) {
		listener?.didSelectedDogSpecies(dropDown.dataSource[indexPath.row])
	}
}
