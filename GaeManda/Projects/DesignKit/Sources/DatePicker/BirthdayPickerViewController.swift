//
//  BirthdayPickerViewController.swift
//  DesignKit
//
//  Created by 김영균 on 10/24/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import GMDExtensions

protocol BirthdayPickerPresentableListener: AnyObject {
    func dismiss()
    func didTapConfirmButton(date: String)
}

final class BirthdayPickerViewController:
    BottomSheetViewController,
    BirthdayPickerPresentable,
    BirthdayPickerViewControllable {
    weak var listener: BirthdayPickerPresentableListener?
    private let disposeBag = DisposeBag()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .b16
        label.textColor = .black
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko_KR")
        picker.minimumDate = Calendar(identifier: .gregorian).date(byAdding: .year, value: -20, to: .now)
        picker.maximumDate = .now
        
        return picker
    }()
    
    private let cancellButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.green100, for: .normal)
        button.titleLabel?.font = .b16
        
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.green100, for: .normal)
        button.titleLabel?.font = .b16
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 32
        
        return stackview
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setViewHierarchy()
        setConstraints()
        bind()
    }
    
    private func setViewHierarchy() {
        self.contentView.addSubviews(dateLabel, datePicker, buttonStackView)
        self.buttonStackView.addArrangedSubviews(cancellButton, confirmButton)
    }
    
    private func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(32)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        self.didDismissBottomSheet
            .bind(with: self, onNext: { owner, _ in
                owner.listener?.dismiss()
            })
            .disposed(by: disposeBag)
        
        self.cancellButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
        
        self.datePicker.rx.date
            .map { $0.toString(format: "yyyy년 MM월") }
            .bind(to: self.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.confirmButton.rx.tap
            .withLatestFrom(datePicker.rx.date) { _, date in
                date.toString(format: "yyyy년 MM월 dd일")
            }
            .bind(with: self, onNext: { owner, date in
                owner.dismissBottomSheet()
                owner.listener?.didTapConfirmButton(date: date)
            })
            .disposed(by: disposeBag)
    }
}
