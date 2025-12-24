//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 4/2/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation

public extension String {
  
  func toDate(format: DateFormatType) -> Date? {
    Date.formatter(with: format).date(from: self)
  }
  
  func relativeText(format: DateFormatType = .yearMonthDay) -> String {
    guard let date = self.toDate(format: format) else {
      return ""
    }
    return date.relativeText()
    }
}

public extension String {
  /// 한글 문자열에서 초성을 추출하는 함수
  var extractChoseong: Self {
    var result = ""
    
    // 한글 유니코드 범위: AC00-D7A3
    let hangulStart: UInt32 = 0xAC00
    let hangulEnd: UInt32 = 0xD7A3
    
    // 초성 배열 - 한글 자모 순서
    let choseong: [Character] = [
      "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
      "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    for scalar in self.unicodeScalars {
      let charCode = scalar.value
      
      // 한글 범위 내 문자인지 확인
      if charCode >= hangulStart && charCode <= hangulEnd {
        // 한글 초성 인덱스 계산
        let index = Int((charCode - hangulStart) / 588) // 초성 인덱스 계산
        result.append(choseong[index])
      } else {
        // 한글이 아닌 문자는 그대로 추가
        result.append(Character(UnicodeScalar(charCode)!))
      }
    }
    return result
  }
  
  var isKoreanConsonants: Bool {
    // 한글 자음 집합
    let consonants = Set("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
    // 모든 문자가 한글 자음인지 확인
    return !self.isEmpty && self.allSatisfy { consonants.contains($0) }
  }
}
