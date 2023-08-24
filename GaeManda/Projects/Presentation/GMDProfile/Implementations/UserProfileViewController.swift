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
	func dogProfileEditButtonDidTap()
	func userProfileEditButtonDidTap()
}

final class UserProfileViewController:
	UIViewController,
	UserProfileViewControllable {
	weak var listener: UserProfilePresentableListener?
	private let disposeBag = DisposeBag()
	private var dogsCount = 0
	
	// MARK: - UI Components
	private let notificationButton: UIButton = {
		let button = UIButton()
		let image = UIImage(
			systemName: "bell",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)
		)
		
		button.setImage(image, for: .normal)
		button.tintColor = .black
		
		return button
	}()
	
	private let settingButton: UIButton = {
		let button = UIButton()
		let image = UIImage(
			systemName: "gearshape",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)
		)
		
		button.setImage(image, for: .normal)
		button.tintColor = .black
		
		return button
	}()
	
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
		collectionView.register(
			DogsCollectionViewCell.self,
			forCellWithReuseIdentifier: DogsCollectionViewCell.idenfier
		)
		collectionView.layer.cornerRadius = 4
		
		return collectionView
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.delegate = self
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
		view.backgroundColor = .white
		title = "프로필"
		
		setNavigationTitleFont(.b20)
		
		setupSubviews()
		setConstraints()
		setNavigationBarButton()
		bind()
	}
	
	func setupSubviews() {
		view.addSubview(nickNameLabel)
		view.addSubview(profileEditButton)
		view.addSubview(sexAndAgeLabel)
		view.addSubview(profileImageView)
		view.addSubview(indicatorView)
		view.addSubview(collectionView)
	}
	
	func setConstraints() {
		nickNameLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(160)
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

// MARK: - Navigation Button Setting
private extension UserProfileViewController {
	func setNavigationBarButton() {
		let notificationBarButton = UIBarButtonItem(customView: notificationButton)
		let settingBarButton = UIBarButtonItem(customView: settingButton)
		
		navigationItem.rightBarButtonItems = [settingBarButton, notificationBarButton]
	}
}

// MARK: - Bind
private extension UserProfileViewController {
	private func bind() {
		collectionViewBind()
		
		profileEditButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.userProfileEditButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
	
	private func collectionViewBind() {
		collectionView.rx.didEndDecelerating
			.withUnretained(self)
			.observe(on: MainScheduler.asyncInstance)
			.bind { owner, _ in
				/// move Page When the page in boundary
				owner.movePageInBoundary()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - UserProfilePresentable
extension UserProfileViewController: UserProfilePresentable {
	func updateUserName(_ name: String) {
		nickNameLabel.text = name
	}
	
	func updateUserSexAndAge(_ sexAndAge: String) {
		sexAndAgeLabel.text = sexAndAge
	}
}

// MARK: - CollectionView Infinite Carousel
private extension UserProfileViewController {
	func movePageInBoundary() {
		let page = Int(collectionView.contentOffset.x / collectionView.frame.width)
		var index = page
		
		if page == 0 {
			collectionView.scrollToItem(
				at: IndexPath(row: dogsCount, section: 0),
				at: .right,
				animated: false
			)
			index = dogsCount
		} else if page == dogsCount + 1 {
			collectionView.scrollToItem(
				at: IndexPath(row: 1, section: 0),
				at: .right,
				animated: false
			)
			index = 1
		}
		
		/// Indicator UI Change
		indicatorView.indicatorDidChange(index - 1)
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
