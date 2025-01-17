// Created for weg-li in 2021.

import ComposableArchitecture
import Helper
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct EditDescriptionView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: Store<DescriptionState, DescriptionAction>
  @ObservedObject private var viewStore: ViewStore<DescriptionState, DescriptionAction>
  
  public init(store: Store<DescriptionState, DescriptionAction>) {
    self.store = store
    viewStore = ViewStore(store)
  }
  
  public var body: some View {
    NavigationView {
      Form {
        Section(header: Text(L10n.Description.Section.Vehicle.copy)) {
          licensePlateView

          carBrandView

          carColorView
        }
        .padding(.top, 4)
        .textFieldStyle(PlainTextFieldStyle())
        
        Section(header: Text(L10n.Description.Section.Violation.copy)) {
          chargTypeView

          chargeLengthView

          blockedOthersView
        }
      }
      .navigationTitle(Text(L10n.Description.widgetTitle))
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(leading: closeButton)
    }
  }
  
  var licensePlateView: some View {
    TextField(
      "\(L10n.Description.Row.licenseplateNumber) *",
      text: viewStore.binding(
        get: \.licensePlateNumber,
        send: DescriptionAction.setLicensePlateNumber
      )
    )
  }
  
  var carBrandView: some View {
    Picker(
      L10n.Description.Row.carType,
      selection: viewStore.binding(
        get: \.selectedBrand,
        send: DescriptionAction.setBrand
      )
    ) {
      ForEach(1..<DescriptionState.brands.count, id: \.self) {
        Text(DescriptionState.brands[$0])
          .tag($0)
          .foregroundColor(Color(.label))
      }
    }
  }
  
  var carColorView: some View {
    Picker(
      L10n.Description.Row.carColor,
      selection: viewStore.binding(
        get: \.selectedColor,
        send: DescriptionAction.setColor
      )
    ) {
      ForEach(1..<DescriptionState.colors.count, id: \.self) {
        Text(DescriptionState.colors[$0].value)
          .tag($0)
          .foregroundColor(Color(.label))
      }
    }
  }
  
  var chargTypeView: some View {
    Picker(
      selection: viewStore.binding(
        get: \.selectedType,
        send: DescriptionAction.setCharge
      ),
      label: Text(L10n.Description.Row.chargeType),
      content: {
        ForEach(1..<DescriptionState.charges.count, id: \.self) { index in
          let charge = DescriptionState.charges[index].value
          chargeView(charge)
            .tag(index)
        }
      })
  }
  
  @ViewBuilder private func chargeView(_ charge: String) -> some View {
    VStack(alignment: .leading) {
      HStack {
        Text(charge)
          .foregroundColor(Color(.label))
          .multilineTextAlignment(.leading)
        Spacer()
      }
    }
  }
  
  var chargeLengthView: some View {
    Picker(
      L10n.Description.Row.length,
      selection: viewStore.binding(
        get: \.selectedDuration,
        send: DescriptionAction.setDuraration
      )
    ) {
      ForEach(1..<Times.allCases.count, id: \.self) {
        Text(Times.allCases[$0].description)
          .foregroundColor(Color(.label))
      }
    }
  }
  
  var blockedOthersView: some View {
    Button(
      action: {
        viewStore.send(.toggleBlockedOthers)
      },
      label: {
        HStack {
          Text(L10n.Description.Row.didBlockOthers)
            .foregroundColor(.secondary)
          Spacer()
          ToggleButton(
            isOn: viewStore.binding(
              get: \.blockedOthers,
              send: DescriptionAction.toggleBlockedOthers
            )
          ).animation(.easeIn(duration: 0.2), value: viewStore.blockedOthers)
        }
      }
    )
  }
  
  var closeButton: some View {
    Button(
      action: { presentationMode.wrappedValue.dismiss() },
      label: { Text(L10n.Button.close) }
    )
  }
}

struct Description_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      EditDescriptionView(
        store: .init(
          initialState: .init(),
          reducer: .empty,
          environment: ()
        )
      )
    }
  }
}
