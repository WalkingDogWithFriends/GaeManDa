//
//  BirthdayPickerInteractor.swift
//  DesignKit
//
//  Created by 김영균 on 9/23/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

public protocol BirthdayPickerRouting: ViewableRouting {}

protocol BirthdayPickerPresentable: Presentable {
    var listener: BirthdayPickerPresentableListener? { get set }
}

final class BirthdayPickerInteractor:
    PresentableInteractor<BirthdayPickerPresentable>, BirthdayPickerInteractable,
    BirthdayPickerPresentableListener {
    weak var router: BirthdayPickerRouting?
    weak var listener: BirthdayPickerListener?
    
    override init(presenter: BirthdayPickerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapConfirmButton(date: String) {
        listener?.birthdaySelected(date: date)
    }
    
    func dismiss() {
        listener?.birthdayPickerDismiss()
    }
}
