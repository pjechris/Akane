//
// This file is part of Akane
//
// Created by JC on 04/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

/**
 Provides a minimalistic API tailored to bind a `Element` with a view field.

 **Tip:** restricted accesses/methods are intended: if you feel you are stuck because of
 the API, then it probably means you need to move your code to a
 `ComponentViewModel` or a `Converter` instead.
 */
public class AnyObserver<Element> : Observer {
    var value: Element? = nil {
        didSet { self.runNext() }
    }

    var next: [(Element -> Void)] = [] {
        didSet { self.runNext() }
    }

    init() {
    }

    convenience init(value: Element) {
        self.init()
        self.value = value
    }

    deinit {
        self.unobserve()
    }
}

// MARK : Convert
extension AnyObserver {
    public func convert<NewElement>(transformer: (Element -> NewElement)) -> AnyObserver<NewElement> {

        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer(value))
        }
    }

    /**
     Converts the observed event value to a new value by applying the `transformer` argument.

     - parameter transformer: `Converter` class used to transform the observation value.

     - returns: A new `AnyObserver` whose observation is the current converted observation value.
     */
    public func convert<T: Converter where T.ValueType == Element>(transformer: T.Type) -> AnyObserver<T.ConvertValueType> {

        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer.init().convert(value))
        }
    }

    public func convert<T: protocol<Converter, ConverterOption> where T.ValueType == Element>(transformer: T.Type, options:() -> T.ConvertOptionType) -> AnyObserver<T.ConvertValueType> {
        
        return self.observeNext{ nextObserver, value in
            let newValue = transformer.init(options: options()).convert(value)

            nextObserver.value(newValue)
        }
    }
}

// MARK : ConvertBack
extension AnyObserver {
    /**
     Provides a reverse conversion of the event value from `ConvertValueType` to
     `ValueType`.

     - parameter converter: The converter type to use to transform the
     observation value.

     - returns: A new AnyObserver whose value is the converted current `Element`.
     */
    public func convertBack<T: ConverterReverse where T.ConvertValueType == Element>(transformer: T.Type) -> AnyObserver<T.ValueType> {
        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer.init().convertBack(value))
        }
    }

    public func convertBack<T: protocol<ConverterReverse, ConverterOption> where T.ConvertValueType == Element>(transformer: T.Type, options:() -> T.ConvertOptionType) -> AnyObserver<T.ValueType> {

        return self.observeNext { nextObserver, value in
            let newValue = transformer.init(options: options()).convertBack(value)

            nextObserver.value(newValue)
        }
    }
}

// MARK : BindTo
extension AnyObserver {
    /**
     Updates `Bindable` with current `Element` value.

     - parameter bindable: The bindable item. Should be a view attribute, such as
     the text of a label.
     */
    public func bindTo<T: Bindable where T.Element == Element>(bindable: T) {
        self.next.append { value in
            bindable.advance()(value)
        }
    }

    /**
     Updates `Bindable` with current optional `Element` value.

     - parameter bindable: The optional bindable item. Passing `nil` produces
     a no-op.
     */
    public func bindTo<T: Bindable where T.Element == Optional<Element>>(bindable: T) {
        self.next.append { value in
            bindable.advance()(value)
        }
    }
}