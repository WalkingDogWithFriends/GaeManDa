//
//  DogCharacterDashboardViewController.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol DogCharacterDashboardPresentableListener: AnyObject {
	func viewDidLoad() 
	func didTapAddDogCharacterButton()
	func deletedDogCharacterAt(id: Int)
}

final class DogCharacterDashboardViewController:
	UIViewController,
	DogCharacterDashboardViewControllable {
	// MARK: - Properties
	weak var listener: DogCharacterDashboardPresentableListener?
	private let disposeBag = DisposeBag()
	
	private var selectedCharacters: [DogCharacter] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	
	// MARK: - UI Components
	private let addDogCharacterButton = AddDogCharacterButton()
	private let scrollBar = GMDScrollBar()
	
	private let collectionView = SelectedCharacterCollectionView()
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		listener?.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		setupUI()
		bind()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		scrollBar.visibleWidth = collectionView.bounds.width
	}
}

// MARK: - UI Methods
private extension DogCharacterDashboardViewController {
	func setupUI() { 
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		view.addSubviews(addDogCharacterButton, collectionView, scrollBar)
	}
	
	func setConstraints() {
		addDogCharacterButton.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(40)
		}
		
		collectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(30)
			make.top.equalTo(addDogCharacterButton.snp.bottom).offset(32)
		}
		
		scrollBar.snp.makeConstraints { make in
			make.top.equalTo(collectionView.snp.bottom).offset(20)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.equalTo(8)
		}
	}
}

// MARK: - Bind Methos
private extension DogCharacterDashboardViewController {
	func bind() {
		bindButtons()
		bindCollectionView()
	}
	
	func bindCollectionView() {
		// CollectionView의 ContentWidth가 변경된 경우
		collectionView.rx.contentSize
			.map { $0.width }
			.bind(to: scrollBar.rx.contentWidth)
			.disposed(by: disposeBag)
		
		// CollectionView를 통해 Offset을 조작한 경우
		collectionView.rx.contentOffset
			.map { $0.x }
			.bind(to: scrollBar.rx.contentOffSetX)
			.disposed(by: disposeBag)
		
		// ScrollBar를 통해 Offset을 조작한 경우
		scrollBar.contentOffSetXDidMove
			.withUnretained(self)
			.map { owner, xValue in
				CGPoint(x: xValue, y: owner.collectionView.contentOffset.y)
			}
			.bind(to: collectionView.rx.contentOffset)
			.disposed(by: disposeBag)
		
		// Scroll이 필요 없다면 ScrollBar 투명 처리
		scrollBar.rx.isScrollable
			.map { $0 ? 1.0 : 0.0 }
			.bind(to: scrollBar.rx.alpha)
			.disposed(by: disposeBag)
	}
	
	func bindButtons() {
		addDogCharacterButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapAddDogCharacterButton()
			}
			.disposed(by: disposeBag)
	}
	
	// MARK: - CollectionView Bind
	func bind(for cell: SelectedDogCharacterCell) {
		cell.rx.didTapDeleteButton
			.bind(with: self) { owner, _ in
				owner.listener?.deletedDogCharacterAt(id: cell.characterId)
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - DogCharacterDashboardPresentable
extension DogCharacterDashboardViewController: DogCharacterDashboardPresentable {
	func updateDogCharacters(_ selectedCharacters: [DogCharacter]) {
		self.selectedCharacters = selectedCharacters
	}
}

// MARK: - CollectionViewDataSource
extension DogCharacterDashboardViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return selectedCharacters.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(SelectedDogCharacterCell.self, for: indexPath)
		cell.configure(with: selectedCharacters[indexPath.row])
		bind(for: cell)
		
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DogCharacterDashboardViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		var width: CGFloat = 0.0
		
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			width = layout.itemSize.width
		}
		
		return CGSize(width: width, height: 30)
	}
}
