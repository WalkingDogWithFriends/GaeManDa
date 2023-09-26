//
//  GMDProfileViewController.swift
//  GMDProfileImpl
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

protocol GMDProfilePresentableListener: AnyObject {
	func viewWillAppear()
	func didTapDogProfileEditButton(at id: Int)
	func didTapNewDogButton()
	func didTapDogProfileDeleteButton()
	func didTapGMDProfileEditButton()
}

final class GMDProfileViewController:
	UIViewController,
	GMDProfilePresentable,
	GMDProfileViewControllable {
	// MARK: - Properties
	weak var listener: GMDProfilePresentableListener?
	private let disposeBag = DisposeBag()
	private var carouselViewModel = DogsCarouselViewModel()
	
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
	
	private let profileImageView = RoundImageView()
	
	private let newDogButton: UIButton = {
		let button = UIButton()
		button.setImage(.iconPlusCircle, for: .normal)
		
		return button
	}()
	
	private let dogPageControl = DogPageControl()
		
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
		collectionView.rx.setDelegate(self).disposed(by: disposeBag)
		collectionView.rx.setDataSource(self).disposed(by: disposeBag)
		
		setupUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		showTabBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		listener?.viewWillAppear()
	}
}

// MARK: - UI Setting
private extension GMDProfileViewController {
	func setupUI() {
		view.backgroundColor = .white
		
		navigationController?.navigationBar.isHidden = true
		navigationBar.backButton.isHidden = true
		
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
			newDogButton,
			dogPageControl,
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
			make.top.equalTo(navigationBar.snp.bottom).offset(72)
		}
		
		profileEditButton.snp.makeConstraints { make in
			make.leading.equalTo(nickNameLabel.snp.trailing).offset(12)
			make.top.equalTo(nickNameLabel)
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
			make.height.width.equalTo(140)
		}
		
		newDogButton.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(36)
			make.leading.equalTo(collectionView)
			make.height.width.equalTo(32)
		}
		
		dogPageControl.snp.makeConstraints { make in
			make.centerY.equalTo(newDogButton)
			make.leading.equalTo(newDogButton.snp.trailing).offset(10)
		}
				
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(76)
			make.leading.equalToSuperview().offset(28)
			make.trailing.equalToSuperview().offset(-28)
			make.height.equalTo(102)
		}
	}
}

// MARK: - UI Update
extension GMDProfileViewController {
	func updateUserName(_ name: String) {
		nickNameLabel.text = name
	}
	
	func updateUserSexAndAge(_ sexAndAge: String) {
		sexAndAgeLabel.text = sexAndAge
	}
	
	func updateDogs(with viewModel: DogsCarouselViewModel) {
		self.carouselViewModel = viewModel
		updateCollectionView()
		updateDogPageControl()
	}
	
	func updateCollectionView() {
		collectionView.reloadData()
		collectionView.isScrollEnabled = carouselViewModel.dogsCount != 1
		scrollCollectionView(at: 1, at: .right)
	}
	
	func updateDogPageControl() {
		dogPageControl.setNumberOfPages(with: carouselViewModel.dogsCount)
		setDogPageControlConstraints(with: carouselViewModel.dogsCount)
	}
	
	func setDogPageControlConstraints(with dogsCount: Int) {
		if dogsCount == 3 {
			newDogButton.isHidden = true
			dogPageControl.snp.remakeConstraints { make in
				make.centerY.equalTo(newDogButton)
				make.leading.equalTo(collectionView)
			}
		} else {
			newDogButton.isHidden = false
			dogPageControl.snp.remakeConstraints { make in
				make.centerY.equalTo(newDogButton)
				make.leading.equalTo(newDogButton.snp.trailing).offset(10)
			}
		}
	}
}

// MARK: - Action Bind
private extension GMDProfileViewController {
	func bind() {
		profileEditButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapGMDProfileEditButton()
			}
			.disposed(by: disposeBag)
		
		newDogButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapNewDogButton()
			}
			.disposed(by: disposeBag)	}
	
	func bind(to cell: DogsCollectionViewCell) {
		cell.rx.editButtonDidTapped
			.bind(with: self) { owner, _ in
				owner.listener?.didTapDogProfileEditButton(at: cell.dogID)
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
extension GMDProfileViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return carouselViewModel.dogs.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(
			DogsCollectionViewCell.self,
			for: indexPath
		)
		let dog = carouselViewModel.dogs[indexPath.row]
		cell.configure(with: dog)
		bind(to: cell)
		
		return cell
	}
}

// MARK: - UIScrollViewDelegate
extension GMDProfileViewController: UIScrollViewDelegate {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		guard let collectionView = scrollView as? UICollectionView else { return }
		
		let page = Int(collectionView.contentOffset.x / collectionView.frame.width)
		let dogsCount = carouselViewModel.dogsCount
		var index = page
		
		if page == 0 {
			scrollCollectionView(at: dogsCount, at: .right)
			index = dogsCount
		} else if page == dogsCount + 1 {
			scrollCollectionView(at: 1, at: .left)
			index = 1
		}
		
		/// Indicator UI Update
		dogPageControl.setCurrentPage(at: index - 1)
	}
}

// MARK: - CollectionView Infinite Carousel
private extension GMDProfileViewController {
	func scrollCollectionView(
		at row: Int,
		at position: UICollectionView.ScrollPosition,
		animated: Bool = false
	) {
		guard row >= 0 && row < carouselViewModel.dogs.count else { return }
		
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
extension GMDProfileViewController: UICollectionViewDelegateFlowLayout {
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
