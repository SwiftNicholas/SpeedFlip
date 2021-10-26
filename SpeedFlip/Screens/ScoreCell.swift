//
//  ScoreCell.swift
//  SpeedFlip
//
//  Created by Nicholas Verrico on 10/25/21.
//

import SwiftUI

struct ScoreCell: View {
    var username: String
    var time: String
    
    var body: some View {
        VStack {
            HStack{
                Text(username)
                    .font(font)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                Text(time)
                    .font(font)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    
            }
        }
            .clipShape(Rectangle())
            .overlay(Rectangle().stroke(Color.gray, lineWidth: 0.5))
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .background(Color.clear)
    }
    
    let font: Font = Font.system(size: 40, weight: .medium, design: .default)
}

struct ScoreCell_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ScoreCell(username: "mstvince", time: "1:45")
            ScoreCell(username: "mstvince", time: "1:45")
            ScoreCell(username: "mstvince", time: "1:45")
        }.background(Color.clear)
    }
}

