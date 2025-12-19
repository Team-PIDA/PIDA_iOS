//
//  CalculateSimilarityScoreUseCaseImpl.swift
//  SearchDomain
//
//  Created by 조용인 on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SearchDomainInterface

public struct CalculateSimilarityScoreUseCaseImpl: CalculateSimilarityScoreUseCase {
  
  public init() {}
  
  public func execute(_ text: String, query: String) -> Int {
    guard !text.isEmpty, !query.isEmpty else { return 0 }
    
    let normalizedText = text.lowercased()
    let normalizedQuery = query.lowercased()
    
    // 정확히 일치하는 경우 가장 높은 점수
    if normalizedText == normalizedQuery { return 100 }
    // 시작 부분이 일치하는 경우 높은 점수
    if normalizedText.hasPrefix(normalizedQuery) { return 80 }
    // 포함하는 경우 중간 점수
    if normalizedText.contains(normalizedQuery) { return 60 }
    // 각 단어 일치 여부 체크 (공백으로 분리된 단어들)
    let textWords = normalizedText.components(separatedBy: " ")
    let queryWords = normalizedQuery.components(separatedBy: " ")
    for queryWord in queryWords {
      for textWord in textWords {
        if textWord.hasPrefix(queryWord) { return 40 }
      }
    }
    
    // 초성 검색 지원 - 검색어가 모두 한글 자음인 경우
    if isKoreanConsonants(normalizedQuery) {
      // 텍스트의 초성 추출
      let textChoseong = extractChoseong(normalizedText)
      // 초성이 정확히 일치하는 경우
      if textChoseong == normalizedQuery { return 30 }
      // 초성이 시작 부분 일치하는 경우
      if textChoseong.hasPrefix(normalizedQuery) { return 25 }
      // 초성에 검색어가 포함되는 경우
      if textChoseong.contains(normalizedQuery) { return 20 }
      // 단어별 초성 검색
      let textWordChoseongs = textWords.map { extractChoseong($0) }
      for queryChar in normalizedQuery {
        for wordChoseong in textWordChoseongs {
          if wordChoseong.hasPrefix(String(queryChar)) {
            return 15
          }
        }
      }
    }
    return 0
  }
}

extension CalculateSimilarityScoreUseCaseImpl {
  // 한글 문자열에서 초성을 추출하는 함수
  private func extractChoseong(_ text: String) -> String {
    var result = ""
    
    // 한글 유니코드 범위: AC00-D7A3
    let hangulStart: UInt32 = 0xAC00
    let hangulEnd: UInt32 = 0xD7A3
    
    // 초성 배열 - 한글 자모 순서
    let choseong: [Character] = [
      "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
      "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    for scalar in text.unicodeScalars {
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
  
  // 문자열이 한글 자음(초성)으로만 이루어져 있는지 확인하는 함수
  private func isKoreanConsonants(_ text: String) -> Bool {
    // 한글 자음 집합
    let consonants = Set("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
    // 모든 문자가 한글 자음인지 확인
    return !text.isEmpty && text.allSatisfy { consonants.contains($0) }
  }
}
