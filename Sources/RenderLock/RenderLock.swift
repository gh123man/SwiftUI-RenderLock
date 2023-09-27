import Foundation
import SwiftUI

public struct RenderDeferred<Content: View>: View {
    struct DeferrableView: View, Equatable {
        @Binding var signal: Bool
        @ViewBuilder var content: Content
        
        static func == (lhs: DeferrableView, rhs: DeferrableView) -> Bool {
            lhs.signal == rhs.signal
        }
        
        var body: some View {
            content
        }
    }
    
    public init(with signal: Binding<Bool>, content: () -> Content) {
        self._signal = signal
        self.content = content()
    }
    
    public init(with signal: Binding<Bool>, content: Content) {
        self._signal = signal
        self.content = content
    }
    
    @Binding var signal: Bool
    @ViewBuilder var content: Content
    
    public var body: some View {
        return DeferrableView(signal: $signal) {
            content
        }.equatable()
    }
}

public struct RenderLocked<Content: View>: View {
    struct LockedView: View, Equatable {
        @Binding var lock: Bool
        @ViewBuilder var content: Content
        
        static func == (lhs: LockedView, rhs: LockedView) -> Bool {
            if rhs.lock {
                return true
            }
            return false
        }
        
        var body: some View {
            content
        }
    }
    
    public init(with lock: Binding<Bool>, content: Content) {
        self._lock = lock
        self.content = content
    }
    
    public init(with lock: Binding<Bool>, content: () -> Content) {
        self._lock = lock
        self.content = content()
    }
    
    @Binding var lock: Bool
    @ViewBuilder var content: Content
    
    public var body: some View {
        return LockedView(lock: $lock) {
            content
        }.equatable()
    }
}
