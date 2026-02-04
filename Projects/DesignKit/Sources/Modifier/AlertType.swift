//
//  AlertType.swift
//  DesignKit
//
//  Created by Jiyeon on 3/25/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

/// Alert의 타입 정의
public enum AlertType: Equatable {
  case logout
  case withdraw
  case login
  case locationPermission
  case imageUploadFailed

  var title: String {
    switch self {
    case .logout: "정말 로그아웃할까요?"
    case .withdraw: "정말 탈퇴할까요?"
    case .login: "로그인이\n필요한 기능입니다."
    case .locationPermission: "위치접근 동의가 필요합니다"
    case .imageUploadFailed: "첨부된 사진 업로드에 실패했어요."
    }
  }

  var message: String? {
    switch self {
    case .logout, .login: nil
    case .withdraw: "탈퇴하면 되돌릴 수 없어요."
    case .locationPermission: "현재 위치 접근에 대한 권한 동의가 거부되었습니다. '설정 > 개인정보 보호'에서 위치 접근을 허용해주세요."
    case .imageUploadFailed: "개화 상태만 저장되었어요."
    }
  }

  /// 취소 버튼 표시 여부
  var showCancelButton: Bool {
    switch self {
    case .imageUploadFailed: false
    default: true
    }
  }

  var cancel: String {
    return "취소"
  }

  var accept: String {
    switch self {
    case .logout: "로그아웃"
    case .login: "로그인하기"
    case .withdraw: "탈퇴하기"
    case .locationPermission: "설정으로 이동"
    case .imageUploadFailed: "확인"
    }
  }

  /// 에러 스타일 여부 (빨간색 버튼)
  var isError: Bool {
    switch self {
    case .withdraw: true
    default: false
    }
  }
}
