//
//  PlaceInformationView.swift
//  Guide
//
//  Created by Vladislav Likh on 15/05/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaceInfoView: View {
    var image: Image
    var title = "Place name"
    var description = "Place description"
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.gray.opacity(0.4))
                .overlay(
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .mask(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .aspectRatio(1, contentMode: .fit)
                        )
                )
            
            Text(description)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button {
                print("marked")
            } label: {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .frame(height: 65)
                    .foregroundColor(.black)
                    .overlay(
                        Text("Mark as visited")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    )
            }
        }
        .padding()
    }
}

struct PlaceInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceInfoView(image: Image("emptyImage"))
    }
}
