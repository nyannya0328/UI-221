//
//  Home.swift
//  UI-221
//
//  Created by にゃんにゃん丸 on 2021/06/03.
//

import SwiftUI

struct Home: View {
    
    let columns = Array(repeating: GridItem(.flexible(),spacing: 2), count: 3)
    
    @State var count : Int = 2
    var body: some View {
        NavigationView{
            
            VStack{
                
                
                RefereshableScrollView(content: {
                    
                    
                    LazyVGrid(columns: columns, spacing: 2, content: {
                        
                        
                        ForEach(1..<count,id:\.self){index in
                            
                            
                            GeometryReader{proxy in
                                
                                
                                let width = proxy.frame(in:.global).width
                                
                                
                                Image("p\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: width, height: 183)
                                    .cornerRadius(1)
                                
                                
                                
                            }
                            .frame(height: 183)
                            
                            
                        }
                      
                    })
                 .padding()
                    
                    
                }, onReflesh: {control in
                    
                    let delay = 1.3
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        
                        
                        self.count += 1
                        
                        control.endRefreshing()
                        
                    }
                    
                    
                    
                    
                })

                
                
                
            }
            .navigationTitle("PULL")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct RefereshableScrollView<Content : View> : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    
    var content : Content
    
    var onReflesh : (UIRefreshControl) -> ()
    
    var refleshControl = UIRefreshControl()
    
    
    
    
    init(@ViewBuilder content : @escaping ()->Content,onReflesh:@escaping (UIRefreshControl)->()) {
        self.content = content()
        
        self.onReflesh = onReflesh
    }
    
    
   
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let view = UIScrollView()
        
        
        refleshControl.attributedTitle = NSAttributedString(string: "PULL!")
        refleshControl.tintColor = .blue
        refleshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onReflesh), for: .valueChanged)
        
        setupView(view: view)
        
        
      
        view.refreshControl = refleshControl
        
        
       
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        
        setupView(view: uiView)
        
    }
    
    func setupView(view : UIScrollView){
        
        let hostView = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let contains = [
        
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
           
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,constant: 1)
        
        
        ]
        view.subviews.last?.removeFromSuperview()
        
        view.addSubview(hostView.view)
        
        view.addConstraints(contains)
        
        
    }
    
    
    class Coordinator : NSObject{
        
        var parent : RefereshableScrollView
        
        init(parent : RefereshableScrollView) {
            self.parent = parent
        }
        
        @objc func onReflesh(){
            
            parent.onReflesh(parent.refleshControl)
            
            
        }
        
        
        
    }
}
