//
//  ContentView.swift
//  RenderLockExample
//
//  Created by Brian Floersch on 9/26/23.
//

import SwiftUI
import RenderLock

struct DebugView<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    var body: some View {
        let _ = Self._printChanges()
        content
    }

}

struct ContentView: View {
    
    
    var body: some View {
        VStack {
            Example()
            Spacer()
            Text("Render Locked")
                .font(.title)
            LockedDemo()
            
            Spacer()
            Divider()
            Spacer()
            
            Text("Render Deferred")
                .font(.title)
            DeferDemo()
            Spacer()
        }
    }
}


struct Example: View {
    
    @State var count = 0
    @State var lock = false
    
    var body: some View {
        VStack {
            HStack {
                Text("\(count)")
                    .renderLocked(with: $lock)
            }
            Button("+1") {
                count += 1
            }
            Button("Lock") {
                lock.toggle()
            }
        }
    }
}

struct LockedDemo: View {
    
    @State var count = 0
    @State var lock = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Text("Render lock")
                    Text("\(count)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .renderLocked(with: $lock)
                }
                VStack {
                    Text("Control")
                    Text("\(count)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 30)
            
            Button("+1") {
                count += 1
            }
            Button(lock ? "unlock" : "lock", role: lock ? .destructive : .cancel) {
                lock.toggle()
            }
            .buttonStyle(.borderedProminent)
        }.padding()
    }
}


struct DeferDemo: View {
    
    @State var count = 0
    @State var signal = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Text("Even only")
                    Text("\(count)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .renderDeferred(with: $signal)
                }
                VStack {
                    Text("Control")
                    Text("\(count)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 30)
            
            Button("+1") {
                count += 1
                if count % 2 == 0 {
                    // Only trigger an event to redraw the view when count is even
                    signal.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }.padding()
    }
}

#Preview {
    ContentView()
}
