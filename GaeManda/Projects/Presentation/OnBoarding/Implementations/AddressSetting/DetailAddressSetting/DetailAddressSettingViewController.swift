//
//  DetailAddressSettingViewController.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import GMDExtensions
import GMDUtils

protocol DetailAddressSettingPresentableListener: AnyObject {
	func detailAddressSettingDidDismiss()
	func closeButtonDidTap()
	func loadLocationButtonDidTap()
}

final class DetailAddressSettingViewController:
	UIViewController,
	DetailAddressSettingPresentable,
	DetailAddressSettingViewControllable {	
	weak var listener: DetailAddressSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let topStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 20
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill
		
		return stackView
	}()
	
	private let topBarView: UIView = {
		let view = UIView()
		
		return view
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "주소 검색"
		label.font = .b16
		
		return label
	}()
	
	private let closeButton: UIButton = {
		let button = UIButton()
		let image = UIImage(
			systemName: "xmark",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
		)
		button.setImage(image, for: .normal)
		button.tintColor = .black
		
		return button
	}()
	
	private let textField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "지번, 도로명, 건물명으로 검색"
		textField.layer.cornerRadius = 7
		textField.layer.borderWidth = 1.2
		textField.layer.borderColor = UIColor.black.cgColor
		let image = UIImage(
			systemName: "magnifyingglass",
			withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
		)
		textField.setLeftImage(image, size: 15, leftPadding: 8)
		textField.setPlaceholdColor(.gray90)
		textField.font = .r12
		
		return textField
	}()
	
	private let loadLocationButton: UIButton = {
		let button = UIButton()
		var configuration = UIButton.Configuration.plain()
		let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
		let image = UIImage(
			systemName: "location.north.circle.fill",
			withConfiguration: imageConfiguration
		)
		configuration.image = image
		configuration.imagePadding = 10
		
		var titleAttribute = AttributedString.init("현재 위치로 설정")
		titleAttribute.font = .b12
		configuration.attributedTitle = titleAttribute
		
		configuration.contentInsets = NSDirectionalEdgeInsets(
			top: 4,
			leading: 0,
			bottom: 4,
			trailing: 0
		)
		configuration.background.backgroundColor = .black
		
		button.configuration = configuration
		button.tintColor = .white
		button.layer.cornerRadius = 4
		
		return button
	}()
	
	private let bottomView: UIView = {
		let view = UIView()
		view.backgroundColor = .init(hexCode: "#F6F6F6")
		
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white

		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(topStackView)
		view.addSubview(bottomView)
		
		topBarView.addSubview(titleLabel)
		topBarView.addSubview(closeButton)
		
		topStackView.addArrangedSubview(topBarView)
		topStackView.addArrangedSubview(textField)
		topStackView.addArrangedSubview(loadLocationButton)
	}
	
	private func setConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
			topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			
			topBarView.heightAnchor.constraint(equalToConstant: 28),
			titleLabel.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
			titleLabel.topAnchor.constraint(equalTo: topBarView.topAnchor),
			closeButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor),
			closeButton.topAnchor.constraint(equalTo: topBarView.topAnchor),
			textField.heightAnchor.constraint(equalToConstant: 32),
			loadLocationButton.heightAnchor.constraint(equalToConstant: 28),
			
			bottomView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 36),
			bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func bind() {
		self.rx.viewDidDisappear
			.withUnretained(self)
			.subscribe(
				onNext: { owner, _ in
					owner.listener?.detailAddressSettingDidDismiss()
				}
			)
			.disposed(by: disposeBag)
		
		loadLocationButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.loadLocationButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		closeButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.closeButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}
