# Refresher

A simple library to enable precise control of rendering a view.  


Sometimes you may want to pause all view updates despite how the environment is changing. This library makes it easy to pause or manually trigger view redrawing. 

This library is so simple, you can just copy/paste the [relevent struct](https://github.com/gh123man/SwiftUI-RenderLock/blob/master/Sources/RenderLock/RenderLock.swift) or depend on it as a Swift package. 

## Example


![render](https://github.com/gh123man/SwiftUI-RenderLock/assets/959778/635853c0-0c08-4791-8b32-b19cc51f1fe8)


## Usage 
First add the package to your project. 

```swift
import RenderLock 

struct Example: View {
    
    @State var count = 0
    @State var lock = false
    
    var body: some View {
        VStack {
            HStack {
                // All subviews will only be redrawn with lock is false
                RenderLocked(with: $lock) {
                    Text("\(count)")
                }
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
```

## How it works

SwiftUI [provides the `equatable()` method](https://developer.apple.com/documentation/swiftui/view/equatable()):
> Prevents the view from updating its child view when its new value is the same as its old value.

So we can exploit this behavior by wrapping any view in an equatable wrapper and then explicitly toggling it's equality with a `@State` variable. `RenderLocked` will only redraw it's subviews when `lock` is false. It works like this:

```swift
@Binding var lock: Bool

static func == (lhs: LockedView, rhs: LockedView) -> Bool {
    if rhs.lock {
        return true
    }
    return false
}
```

A beneficial side effect of this behavior is the view is signaled to redraw when unlocked. So any view updates that were previously blocked will be applied immediately.

## But Wait, There's More!

This library also includes `RenderDeferred` which uses the same concept, but instead of locking or unlocking view updates, it only updates when signaled: `RenderDeferred(with: $signal)` where `signal` is a `Bool`. 

This can be useful if you want to tie all view updates to a timer, or another control. 
