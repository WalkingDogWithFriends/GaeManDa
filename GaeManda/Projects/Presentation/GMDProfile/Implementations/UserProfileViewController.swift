//
//  UserProfileViewController.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol UserProfilePresentableListener: AnyObject {
	func viewWillAppear()
	func didTapDogProfileEditButton()
	func didTapDogProfileDeleteButton()
	func didTapUserProfileEditButton()
}

final class UserProfileViewController:
	UIViewController,
	UserProfilePresentable,
	UserProfileViewControllable {
	weak var listener: UserProfilePresentableListener?
	private let disposeBag = DisposeBag()
	private var dogs: [Dog] = []
	var dogsCount: Int {
		dogs.isEmpty ? 0 : dogs.count - 2
	}
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "프로필")
	
	private let nickNameLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.textColor = .black
		
		return label
	}()
	
	private let profileEditButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = .r12
		button.layer.borderColor = UIColor.gray50.cgColor
		button.layer.cornerRadius = 10
		button.layer.borderWidth = 1
		
		return button
	}()
	
	private let sexAndAgeLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.textColor = .black
		
		return label
	}()
	
	private let profileImageView: RoundImageView = {
		let roundImageView = RoundImageView()
		roundImageView.backgroundColor = .systemGray
		
		return roundImageView
	}()
	
	private let indicatorView: IndicatorView = {
		let indicatorView = IndicatorView()
		
		return indicatorView
	}()
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.isPagingEnabled = true
		collectionView.backgroundColor = .gray40
		collectionView.registerCell(DogsCollectionViewCell.self)
		collectionView.layer.cornerRadius = 4
		
		return collectionView
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		showTabBar()
		listener?.viewWillAppear()
	}
}

// MARK: - UI Setting
private extension UserProfileViewController {
	func setupUI() {
		navigationController?.navigationBar.isHidden = true
		navigationBar.backButton.isHidden = true
		view.backgroundColor = .white
		
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(
			navigationBar,
			nickNameLabel,
			profileEditButton,
			sexAndAgeLabel,
			profileImageView,
			indicatorView,
			collectionView
		)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		nickNameLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(navigationBar.snp.bottom).offset(70)
		}
		
		profileEditButton.snp.makeConstraints { make in
			make.leading.equalTo(nickNameLabel.snp.trailing).offset(12)
			make.centerY.equalTo(nickNameLabel)
			make.width.equalTo(40)
			make.height.equalTo(20)
		}
		
		sexAndAgeLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(nickNameLabel.snp.bottom).offset(12)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(sexAndAgeLabel.snp.bottom).offset(12)
			make.height.width.equalTo(160)
		}
		
		indicatorView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(32)
			make.trailing.equalTo(collectionView)
		}
		
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(indicatorView.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(29)
			make.trailing.equalToSuperview().offset(-29)
			make.height.equalTo(102)
		}
	}
}

// MARK: - UI Update
extension UserProfileViewController {
	func updateUserName(_ name: String) {
		nickNameLabel.text = name
	}
	
	func updateUserSexAndAge(_ sexAndAge: String) {
		sexAndAgeLabel.text = sexAndAge
	}
	
	func updateDogs(_ dogs: [Dog]) {
		self.dogs = getInfiniteCarouselCellData(by: dogs)
		collectionView.reloadData()
		collectionView.isScrollEnabled = dogs.count == 1 ? false : true
		scrollCollectionView(at: 1, at: .right)
		indicatorView.indicatorCount = dogs.count
	}
}

// MARK: - Action Bind
private extension UserProfileViewController {
	func bind() {
		profileEditButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.didTapUserProfileEditButton()
			}
			.disposed(by: disposeBag)
	}
	
	func bind(to cell: DogsCollectionViewCell) {
		cell.rx.editButtonDidTapped
			.bind(with: self) { owner, _ in
				owner.listener?.didTapDogProfileEditButton()
			}
			.disposed(by: disposeBag)
		
		cell.rx.deleteButtonDidTapped
			.bind(with: self) { owner, _ in
				owner.listener?.didTapDogProfileDeleteButton()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - UICollectionViewDataSource
extension UserProfileViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dogs.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(
			DogsCollectionViewCell.self,
			for: indexPath
		)
		let dog = dogs[indexPath.row]
		cell.configure(with: dog)
		bind(to: cell)
		
		return cell
	}
}

// MARK: - UIScrollViewDelegate
extension UserProfileViewController: UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		guard let collectionView = scrollView as? UICollectionView else { return }
		
		let page = Int(collectionView.contentOffset.x / collectionView.frame.width)
		var index = page
		
		if page == 0 {
			scrollCollectionView(at: dogsCount, at: .right)
			index = dogsCount
		} else if page == dogsCount + 1 {
			scrollCollectionView(at: 1, at: .left)
			index = 1
		}
		
		/// Indicator UI Update
		indicatorView.collectionViewDidChange(index: index - 1)
	}
}

// MARK: - CollectionView Infinite Carousel
private extension UserProfileViewController {
	func getInfiniteCarouselCellData(by dogs: [Dog]) -> [Dog] {
		guard
			let last = dogs.last,
			let first = dogs.first
		else {
			return dogs
		}
		var dogsForCell = dogs
		
		dogsForCell.insert(last, at: 0)
		dogsForCell.append(first)
		
		return dogsForCell
	}
	
	func scrollCollectionView(
		at row: Int,
		at position: UICollectionView.ScrollPosition,
		animated: Bool = false
	) {
		guard row >= 0 && row < dogs.count else { return }
		
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.scrollToItem(
				at: IndexPath(row: row, section: 0),
				at: position,
				animated: false
			)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(
			width: collectionView.frame.width,
			height: collectionView.frame.height
		)
	}
}
