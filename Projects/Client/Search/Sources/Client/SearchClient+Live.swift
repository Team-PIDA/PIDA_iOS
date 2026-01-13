//
//  SearchClient+Live.swift
//  SearchClient
//
//  Created by 조용인 on 12/21/25.
//  Copyright © 2025 com.pida.me. All rights reserved.
//

import ComposableArchitecture
import CacheClient
import Shared

extension SearchClient: DependencyKey {
  public static var liveValue: SearchClient {
    @Dependency(\.cache) var cache
    
    return .init(
      calculateSimilarityScore: { text, query in
        guard let text, !text.isEmpty, !query.isEmpty else { return 0 }
        
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
        if normalizedQuery.isKoreanConsonants {
          // 텍스트의 초성 추출
          let textChoseong = normalizedText.extractChoseong
          // 초성이 정확히 일치하는 경우
          if textChoseong == normalizedQuery { return 30 }
          // 초성이 시작 부분 일치하는 경우
          if textChoseong.hasPrefix(normalizedQuery) { return 25 }
          // 초성에 검색어가 포함되는 경우
          if textChoseong.contains(normalizedQuery) { return 20 }
          // 단어별 초성 검색
          let textWordChoseongs = textWords.map { $0.extractChoseong }
          for queryChar in normalizedQuery {
            for wordChoseong in textWordChoseongs {
              if wordChoseong.hasPrefix(String(queryChar)) {
                return 15
              }
            }
          }
        }
        return 0
      },
      fetchRecentSearch: {
        guard let items = await cache.get(.recentSearches, as: [SearchListCellEntity].self)
        else { return [] }
        return items
      },
      // NOTE: 질문) 얘가 하는 역할이 뭔지?
      getSearchListFromCache: {
        guard let items = await cache.get(.allFlowerSpots, as: [SearchAddressCacheModel].self)
        else { return [] }
        return items.map { SearchListCellEntity($0) }
      },
      saveRecentSearchItem: { entity in
        guard let allList = await cache.get(.recentSearches, as: [SearchListCellEntity].self)
        else {
          // 캐시에 최근 검색어가 하나도 없으면 새로 생성
          try await cache.set(.recentSearches, [entity])
          return
        }
        var updated = allList
        if let existingIndex = updated.firstIndex(where: { $0.id == entity.id }) {
          updated.remove(at: existingIndex)
        }
        
        if updated.count > 20 { updated.removeLast() }
          
        updated.insert(entity, at: 0)
        try await cache.set(.recentSearches, updated)
      }
    )
  }
}
