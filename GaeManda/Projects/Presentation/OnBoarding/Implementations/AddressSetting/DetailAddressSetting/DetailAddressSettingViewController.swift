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
import SnapKit
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
		let image = UIImage.iconCloseRound
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
		let image = UIImage.iconSearch
		textField.setLeftImage(image, size: 15, leftPadding: 8)
		textField.setPlaceholdColor(.gray90)
		textField.font = .r12
		
		return textField
	}()
	
	private let loadLocationButton: UIButton = {
		let button = UIButton()
		var configuration = UIButton.Configuration.plain()
		let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
		let image = UIImage.iconGps
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
//		view.backgroundColor = .init(hexCode: "#F6F6F6")
		
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
		topStackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(36)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		topBarView.snp.makeConstraints {  make in make.height.equalTo(28)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.leading.top.equalTo(topBarView)
		}
		
		closeButton.snp.makeConstraints { make in
			make.trailing.top.equalTo(topBarView)
		}
		
		textField.snp.makeConstraints { make in
			make.height.equalTo(32)
		}
		
		loadLocationButton.snp.makeConstraints { make in
			make.height.equalTo(28)
		}
		
		bottomView.snp.makeConstraints { make in
			make.top.equalTo(topStackView.snp.bottom).offset(36)
			make.leading.trailing.bottom.equalToSuperview()
		}
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
