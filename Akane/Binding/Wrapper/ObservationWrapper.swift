//
// This file is part of Akane
//
// Created by JC on 04/04/16.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import HasAssociatedObjects

class Binding<Element> {
    private var value: Element? = nil {
        didSet { self.runNext() }
    }
    private var next: [(Element -> Void)] = [] {
        didSet { self.runNext() }
    }

    init() {

    }

    deinit {
        self.unbind()
    }

    func value(value: Element) {
        self.value = value
    }

    func runNext() {
        if let value = self.value {
            for step in self.next {
                step(value)
            }
        }
    }

    func observeNext<NewElement>(yield: ((AnyBinding<NewElement>, Element) -> Void))  -> AnyBinding<NewElement> {
        let nextObserver = AnyBinding<NewElement>()

        self.next.append { value in
            yield(nextObserver, value)
        }

        return nextObserver
    }

    func next(block: (Element -> Void)) {
        self.next.append(block)
    }

    func unbind() {
        self.next = []
        self.value = nil
    }
}

/**
 Provides a minimalistic API tailored to interact with an `Observation` from withing a `ComponentView`.

 **Tip:** restricted accesses/methods are intended: if you feel you are stuck because of
 the API, then it probably means you need to move your code to a
 `ComponentViewModel` or a `Converter` instead.
 */
public class AnyBinding<Element> {
    private var value: Element? = nil {
        didSet { self.runNext() }
    }
    private var next: [(Element -> Void)] = [] {
        didSet { self.runNext() }
    }

    init() {

    }

    deinit {
        self.unbind()
    }

    convenience init(value: Element) {
        self.init()
        self.value = value
    }

    func value(value: Element) {
        self.value = value
    }

    func runNext() {
        if let value = self.value {
            for step in self.next {
                step(value)
            }
        }
    }

    func observeNext<NewElement>(yield: ((AnyBinding<NewElement>, Element) -> Void))  -> AnyBinding<NewElement> {
        let nextObserver = AnyBinding<NewElement>()

        self.next.append { value in
            yield(nextObserver, value)
        }

        return nextObserver
    }

    func unbind() {
        self.next = []
        self.value = nil
    }
}

// MARK : Convert
extension AnyBinding {
    public func convert<NewElement>(transformer: (Element -> NewElement)) -> AnyBinding<NewElement> {
        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer(value))
        }
    }

    /**
     Converts the observed event value to a new value by applying the `transformer` argument.

     - parameter transformer: `Converter` class used to transform the observation value.

     - returns: A new `AnyBinding` whose observation is the current converted observation value.
     */
    public func convert<T: Converter where T.ValueType == Element>(transformer: T.Type) -> AnyBinding<T.ConvertValueType> {

        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer.init().convert(value))
        }
    }

    public func convert<T: protocol<Converter, ConverterOption> where T.ValueType == Element>(transformer: T.Type, options:() -> T.ConvertOptionType) -> AnyBinding<T.ConvertValueType> {
        
        return self.observeNext{ nextObserver, value in
            let newValue = transformer.init(options: options()).convert(value)

            nextObserver.value(newValue)
        }
    }
}

// MARK : ConvertBack
extension AnyBinding {
    /**
     Provides a reverse conversion of the event value from `ConvertValueType` to
     `ValueType`.

     - parameter converter: The converter type to use to transform the
     observation value.

     - returns: A new ObservationWrapper whose observation is the current
     converted observation value.
     */
    public func convertBack<T: ConverterReverse where T.ConvertValueType == Element>(transformer: T.Type) -> AnyBinding<T.ValueType> {
        return self.observeNext { nextObserver, value in
            nextObserver.value(transformer.init().convertBack(value))
        }
    }

    public func convertBack<T: protocol<ConverterReverse, ConverterOption> where T.ConvertValueType == Element>(transformer: T.Type, options:() -> T.ConvertOptionType) -> AnyBinding<T.ValueType> {

        return self.observeNext { nextObserver, value in
            let newValue = transformer.init(options: options()).convertBack(value)

            nextObserver.value(newValue)
        }
    }
}

// MARK : BindTo
extension AnyBinding {
    /**
     Binds the observation value to a bindable entity.

     - parameter bindable: The bindable item. Should be a view attribute, such as
     the text of a label.
     */
    public func bindTo<T: Bindable where T.Element == Element>(bindable: T) {
        self.next.append { value in
            bindable.advance()(value)
        }
    }

    /**
     Binds the observation value to a optional bindable class.

     - parameter bindable: The optional bindable item. Passing `nil` produces
     a no-op.
     */
    public func bindTo<T: Bindable where T.Element == Optional<Element>>(bindable: T) {
        self.next.append { value in
            bindable.advance()(value)
        }
    }
}