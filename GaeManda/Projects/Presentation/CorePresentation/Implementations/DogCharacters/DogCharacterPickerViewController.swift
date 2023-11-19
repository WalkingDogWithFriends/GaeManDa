//
//  DogCharacterPickerViewController.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions

protocol DogCharacterPickerPresentableListener: AnyObject { 
	func viewDidLoad()
}

final class DogCharacterPickerViewController:
	BottomSheetViewController,
	DogCharacterPickerPresentable,
	DogCharacterPickerViewControllable {
	// MARK: - Properties
	weak var listener: DogCharacterPickerPresentableListener?
	// 강아지 성격리스트
	private var dogCharacterViewModels = [DogCharacterViewModel]()
	
	// MARK: - UI Components
	private let upperView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 5
		view.backgroundColor = .gray60
		
		return view
	}()
	
	private let collectionView: UICollectionView = {
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: DogCharacterCollectionViewLayout()
		)
		collectionView.registerCell(DogCharacterCell.self)
		
		return collectionView
	}()
	
	private let confirmButton = ConfirmButton(title: "완료")
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		setupUI()
		listener?.viewDidLoad()
	}
}

// MARK: - UI Methods
private extension DogCharacterPickerViewController {
	func setupUI() {
		setViewHierarhcy()
		setConstraints()
	}
	
	func setViewHierarhcy() {
		self.topBarView.addSubview(upperView)
		self.contentView.addSubviews(collectionView, confirmButton)
	}
	
	func setConstraints() {
		upperView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.height.equalTo(6)
			make.width.equalTo(40)
			make.top.equalToSuperview().offset(7)
		}
		
		collectionView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(20)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalTo(confirmButton.snp.top)
			make.height.equalTo(152)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalToSuperview().offset(-30)
			make.height.equalTo(40)
		}
	}
}

// MARK: - UICollectionViewDataSource
extension DogCharacterPickerViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dogCharacterViewModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(DogCharacterCell.self, for: indexPath)
		
		cell.configure(with: dogCharacterViewModels[indexPath.item])
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension DogCharacterPickerViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? DogCharacterCell else { return }
		
		cell.isChoice.toggle()

		var selectedCharacter = dogCharacterViewModels
			.filter { $0.id == cell.characterId }
			.first
		
		selectedCharacter?.isChoice = cell.isChoice
	}
}
