//
//  TextFiledModeViewModel.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/09/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DesignKit

struct ScollViewUIComponentMode {
	var nickNameTextFieldMode: GMDTextFieldMode = .normal
	var dogBreedTextFieldMode: GMDTextFieldMode = .normal
	var dogWeightTextFieldMode: GMDTextFieldMode = .normal
	var characterTextViewMode: GMDTextViewMode = .normal
}

extension ScollViewUIComponentMode {
	/// 모든 mode가 normal인지 체크하는 프로퍼티입니다.
	var isValid: Bool {
		nickNameTextFieldMode == .normal &&
		dogBreedTextFieldMode == .normal &&
		dogWeightTextFieldMode == .normal &&
		characterTextViewMode == .normal
	}
}
