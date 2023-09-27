//
//  Created by Brian Floersch on 9/26/23.
//

import Foundation
import SwiftUI

extension View {
    public func renderLocked(with lock: Binding<Bool>) -> some View {
        RenderLocked(with: lock, content: self)
    }
    
    public func renderDeferred(with signal: Binding<Bool>) -> some View {
        RenderDeferred(with: signal, content: self)
    }
}
