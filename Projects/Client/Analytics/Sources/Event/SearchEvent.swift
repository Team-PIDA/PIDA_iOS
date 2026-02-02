//
//  SearchEvent.swift
//  AnalyticsClient
//
//  Created by 조용인 on 1/27/26.
//

import Foundation

// MARK: - SearchEvent

/// 검색 관련 이벤트
public enum SearchEvent: AnalyticsEvent {
  /// 검색창 클릭하여 검색 화면 진입
  case start(
    hasRecentSearches: Bool,
    recentSearchesCount: Int,
    entryPoint: String
  )

  /// 최근 검색어 항목 클릭
  case recentSearchClicked

  /// 검색어 입력 시작
  case input

  /// keyboard에서 검색 버튼 클릭
  case inputSubmitted(resultType: ResultType)

  /// 검색 자동완성 항목 클릭
  case suggestionClicked(resultType: ResultType)

  /// 검색 결과 없음 화면 진입
  case noResultViewed(keywordLength: Int, resultType: ResultType)

  /// 검색 결과 리스트에서 region 선택하여 지도 화면 진입
  case resultViewed(
    entryPoint: String,
    distanceFromRegion: Double?,
    scrollItemCount: Int
  )

  /// 검색 결과 목록 스크롤 발생
  case resultScrolled(
    researchResult: String?,
    currentPage: String,
    resultType: ResultType
  )

  /// 검색 결과 화면에서 '현 위치에서 재검색' 버튼 클릭
  case researchClicked(currentPage: String)

  /// 검색 결과 리스트에서 항목 클릭
  case resultClicked

  public var name: String {
    switch self {
    case .start:
      return "search_start"
    case .recentSearchClicked:
      return "recent_search_clicked"
    case .input:
      return "search_input"
    case .inputSubmitted:
      return "search_input_submitted"
    case .suggestionClicked:
      return "search_suggestion_clicked"
    case .noResultViewed:
      return "search_no_result_viewed"
    case .resultViewed:
      return "search_result_viewed"
    case .resultScrolled:
      return "search_result_scrolled"
    case .researchClicked:
      return "search_research_clicked"
    case .resultClicked:
      return "search_result_clicked"
    }
  }

  public var properties: [String: Any] {
    switch self {
    case let .start(hasRecentSearches, recentSearchesCount, entryPoint):
      return [
        "has_recent_searches": hasRecentSearches,
        "recent_searches_count": recentSearchesCount,
        "entry_point": entryPoint
      ]

    case .recentSearchClicked, .input, .resultClicked:
      return [:]

    case let .inputSubmitted(resultType):
      return ["result_type": resultType.rawValue]

    case let .suggestionClicked(resultType):
      return ["result_type": resultType.rawValue]

    case let .noResultViewed(keywordLength, resultType):
      return [
        "keyword_length": keywordLength,
        "result_type": resultType.rawValue
      ]

    case let .resultViewed(entryPoint, distanceFromRegion, scrollItemCount):
      var props: [String: Any] = [
        "entry_point": entryPoint,
        "scroll_item_count": scrollItemCount
      ]

      if let distanceFromRegion {
        props["distance_from_region"] = distanceFromRegion
      }

      return props

    case let .resultScrolled(researchResult, currentPage, resultType):
      var props: [String: Any] = [
        "current_page": currentPage,
        "result_type": resultType.rawValue
      ]

      if let researchResult {
        props["research_result"] = researchResult
      }

      return props

    case let .researchClicked(currentPage):
      return ["current_page": currentPage]
    }
  }
}

// MARK: - ResultType

public extension SearchEvent {
  /// 검색어 타입 (행정구역, 랜드마크, 꽃길)
  enum ResultType: String, Sendable {
    case district = "district"
    case landmark = "landmark"
    case flowerSpot = "flowerSpot"
  }
}
