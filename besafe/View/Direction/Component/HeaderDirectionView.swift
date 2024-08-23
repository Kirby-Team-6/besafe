//
//  HeaderDirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 19/08/24.
//

import SwiftUI

struct HeaderDirectionView: View {
    @Binding var selection: Int
    @Binding var tabViewCount: Int
    @EnvironmentObject var viewmodel: MainViewModel
    
    var body: some View {
        VStack{
            TabView(selection : $selection){
                ForEach(
                    Array((viewmodel.route?.steps ?? []).enumerated()), id: \.offset) { index, element in
                        let distance = Int(element.distance.rounded())
                        let image = Direction.fromInstruction(element.instructions).toImageName()
                        
                        HStack (alignment: .top){
                            if (distance > 0 && image != nil){
                                Image(image!)
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 20)
                                
                            }
                            
                            VStack(alignment: .leading) {
                                if(distance > 0 ){
                                    Text("\(distance) m")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                
                                Text(element.instructions)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            
                        }
                        
                    }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .padding(.bottom, 0)
            
            PageControlView(currentPage: $selection, numberOfPages: $tabViewCount)
        }
        .padding()
        .background(.black)
        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .top)
        .transition(.move(edge: .top))
        .animation(.default, value: viewmodel.route != nil)
    }
}

//#Preview {
//    HeaderDirectionView()
//}
