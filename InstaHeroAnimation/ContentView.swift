//
//  ContentView.swift
//  InstaHeroAnimation
//
//  Created by Камиль Сулейманов on 28.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State var showDeatail = false
    @State var index = Int()
    @Namespace var animation
    
    var body: some View {
        ZStack{
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 3) {
                    ForEach(0 ..< 30, id: \.self) { item in
                        ZStack {
                            Text(item.description)
                                .matchedGeometryEffect(id: item, in: animation)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(height: (UIScreen.main.bounds.width - 8) / 3)
                                .frame(width: (UIScreen.main.bounds.width - 8) / 3)
                        }
                        .background(Color.green.matchedGeometryEffect(id: item.description, in: animation))
                        .onTapGesture {
                            index = item
                            showDeatail.toggle()}
                        .opacity(index == item && showDeatail ? 0 : 1)
                        .animation(showDeatail ? nil : .spring(response: 0.35, dampingFraction: 1, blendDuration: 0.5))
                    }
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            }
            
            if showDeatail{
                ShowDetail(index: index, animation: animation, showDeatail: $showDeatail)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(height: UIScreen.main.bounds.height)
        .background(Color.black.ignoresSafeArea())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShowDetail: View {
    var index: Int
    var animation: Namespace.ID
    @Binding var showDeatail: Bool
    @State var scroll = true
    @State var viewState: CGSize = .zero
    
    var body: some View{
        ZStack (alignment: .top){
            
            HStack{
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .onTapGesture {showDeatail.toggle()}
            }
            .padding(.trailing, 20)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .zIndex(1)
            
            
            ScrollViewReader { reader in
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing:2)], spacing: 2) {
                        ForEach(0 ..< 30, id: \.self) { item in
                            ZStack {
                                if index != item{
                                    Text(item.description)
                                        
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .frame(width: 400, height: 400)
                                        .background(Color.green)
                                    
                                } else {
                                    ZStack (alignment: .top){
                                        Text("\(index)")
                                            .matchedGeometryEffect(id: item, in: animation)
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                            .frame(width: 400, height: 400)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    .background(Color.green.matchedGeometryEffect(id: item.description, in: animation))
                                    
                                }
                            }
                            .onAppear{
                                if scroll {
                                    reader.scrollTo(index, anchor: .top)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    scroll = false
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.ignoresSafeArea().cornerRadius(35))
        .animation(scroll ? .spring(response: 0.4, dampingFraction: 1, blendDuration: 0.5) : nil)
        .offset(viewState)
        .onTapGesture {} //to avoid drag while scolling
        .gesture(
            DragGesture().onChanged{ value in
                viewState = value.translation
            }
            .onEnded{ value in
                if value.translation.width > 100 || value.translation.width < -100 {
                    showDeatail.toggle()
                }
                viewState = .zero
            }
        )
    }
}
