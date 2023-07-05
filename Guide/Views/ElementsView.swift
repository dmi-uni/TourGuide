//
//  ElementsView.swift
//  Guide
//
//  Created by Vladislav Likh on 31/05/22.
//

import SwiftUI

struct ElementsView: View {
    var body: some View {
        ZStack {
            Color("Pink").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 25) {
                HStack(spacing: 10) {
                    SmallTagView(text: "✈️ traveling")
                    SmallTagView(text: "🍔 food")
                }
                HStack(spacing: 10) {
                    LargeTagView(text: "✈️ traveling")
                    LargeTagView(text: "🍔 food")
                }
            }
        }
    }
}

struct SmallTagView: View {
    var text = "✈️ Traveling"
    var body: some View {
        Text(text.uppercased())
            .padding(.trailing, 2)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            )
    }
}

struct LargeTagView: View {
    var text = "✈️ Traveling"
    var body: some View {
        Text(text.uppercased())
            .padding(.trailing, 2)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            )
    }
}

struct ElementsView_Previews: PreviewProvider {
    static var previews: some View {
        ElementsView()
    }
}
