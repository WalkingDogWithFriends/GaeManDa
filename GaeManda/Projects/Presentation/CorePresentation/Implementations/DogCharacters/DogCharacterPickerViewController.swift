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
	func didTapConfirmButton(with selectedId: [Int])
	func dismiss()
}

final class DogCharacterPickerViewController:
	BottomSheetViewController,
	DogCharacterPickerPresentable,
	DogCharacterPickerViewControllable {
	// MARK: - Properties
	weak var listener: DogCharacterPickerPresentableListener?
	private let disposeBag = DisposeBag()
	// 강아지 성격리스트
	fileprivate var dogCharacterViewModels = [DogCharacterViewModel]()
	
	/// 선택된 성격 Observable
	private let selectedId = BehaviorRelay<[Int]>(value: [])
	
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
		bind()
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

// MARK: - Update Methods
extension DogCharacterPickerViewController {
	func updateDogCharacterCell(_ viewModel: [DogCharacterViewModel]) {
		self.dogCharacterViewModels = viewModel
		let ids = dogCharacterViewModels
			.filter { $0.isChoice }
			.map { $0.id }
		
		selectedId.accept(ids)
		collectionView.reloadData()
	}
}

// MARK: - Bind Methods
private extension DogCharacterPickerViewController {
	func bind() {
		self.didDismissBottomSheet
			.bind(with: self) { owner, _ in
				owner.listener?.dismiss()
			}
			.disposed(by: disposeBag)
		
		self.selectedId
			.map { !$0.isEmpty }
			.bind(to: confirmButton.rx.isPositive)
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.withLatestFrom(self.selectedId)
			.filter { !$0.isEmpty }
			.bind(with: self) { owner, selectedId in
				let sortedId = selectedId.sorted(by: { $0 < $1 })
				owner.listener?.didTapConfirmButton(with: sortedId)
				owner.dismissBottomSheet()
			}
			.disposed(by: disposeBag)
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
		
		cell.isChoice ? appendToSelectedId(cell.characterId) : removeFromSelectedId(cell.characterId)
	}
}

// MARK: - Private Method
private extension DogCharacterPickerViewController {
	func removeFromSelectedId(_ value: Int) {
		var values = selectedId.value
		guard let index = values.firstIndex(of: value) else { return }
		
		values.remove(at: index)
		selectedId.accept(values)
	}
	
	func appendToSelectedId(_ value: Int) {
		var values = selectedId.value
		
		guard !values.contains(where: { $0 == value }) else { return }
		
		values.append(value)
		selectedId.accept(values)
	}
}
