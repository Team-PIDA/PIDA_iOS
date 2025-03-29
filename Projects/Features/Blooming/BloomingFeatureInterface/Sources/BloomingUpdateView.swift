//
//  BloomingUpdateView.swift
//  BloomingFeatureInterface
//
//  Created by Jiyeon on 3/30/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import SwiftUI
import DesignKit
import Utility
import ComposableArchitecture

public struct BloomingUpdateView: View {
  @Bindable var store: StoreOf<BloomingUpdateReducer>
  
  public init(store: StoreOf<BloomingUpdateReducer>) {
    self.store = store
  }
  @State var selectedStatus: BloomStatus? = nil
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        navigationBar
        Spacer()
        VStack(spacing: .Number48) {
          mainTitle
          StateRadioButton(status: $store.selectedStatus)
          
        }
        Spacer()
        saveButton
      }
      
    }
  }
  
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      title: "오늘의 개화상태",
      closeContent:  {
      TouchArea(image: .close)
        .size(.superLarge)
        .action {
          store.send(.dismiss)
        }
      }
    )
  }
  
  
  @ViewBuilder
  private var mainTitle: some View {
    VStack(alignment: .center, spacing: .Number8) {
      VStack(alignment: .center, spacing: .Number0) {
        Text("오늘 방문한")
          .foregroundStyle(ColorSet.Text.Primary)
        HStack(spacing: .Number0) {
          Text(store.streetName)
            .foregroundStyle(ColorSet.Text.Accent)
          Text("의")
            .foregroundStyle(ColorSet.Text.Primary)
        }
        Text("개화상태는 어땠나요?")
          .foregroundStyle(ColorSet.Text.Primary)
      }
      .fontStyle(FontSet.Heading.heading1)
      Text("석촌호수로의 개화 상태를 기록해주세요")
        .fontStyle(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
    }
    
  }
  @ViewBuilder
  private var saveButton: some View {
    PIDButton(title: store.buttonTittle, size: .large)
      .action {
        
      }
      .isActive(store.isButtonEnable)
      .padding(.Number16)
  }
}
