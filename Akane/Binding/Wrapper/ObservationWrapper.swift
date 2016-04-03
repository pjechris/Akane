//
// This file is part of Akane
//
// Created by JC on 01/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

/**
`ObservationWrapper` provides a minimalistic API tailored to interact with an 
`Observation` from withing a `ComponentView`.
 
**Tip:** restricted accesses/methods are intended: if you feel you are stuck because of
the API, then it probably means you need to move your code to a
`ComponentViewModel` or a `Converter` instead.

*/
public class ObservationWrapper<E> {
    public typealias Element = E

    public private(set) var value: E!

    internal let event: EventProducer<E>
    private let disposeBag: DisposeBag

    internal convenience init<T : Observation>(observable: T, attribute: T.Element -> E) {
        let internalObservable = Bond.Observable<E>(attribute(observable.value))
        let disposeBag = CompositeDisposable()

        disposeBag.addDisposable(
            observable.observe { [unowned internalObservable] value in
                internalObservable.next(attribute(value))
            }
        )

        self.init(event: internalObservable, disposeBag: disposeBag)
    }

    internal init(event: EventProducer<E>, disposeBag: DisposeBag) {
        self.event = event
        self.disposeBag = disposeBag
        self.value = nil

        self.event.observe { [weak self] value in
            self?.value = value
        }
    }
    
    // MARK: Binding

    /**
    Binds the observation value to a bindable entity.
    
    - parameter bindable: The bindable item. Should be a view attribute, such as
    the text of a label.
    */
    public func bindTo<T: Bindable where T.Element == Element>(bindable: T) {
        let next = bindable.advance()

        self.onBind({ value in
            // we can safely unwrap bc 1st closure return us Element?, while we indeed have Element
            next(value!)
        })
    }
    
    /**
    Binds the observation value to a optional bindable class.
    
    - parameter bindable: The optional bindable item. Passing `nil` produces
     a no-op.
    */
    public func bindTo<T: Bindable where T.Element == Element?>(bindable: T) {
         self.onBind(bindable.advance())
    }

    public func combine<T: Observation>(observables: T...) -> Self {
        return self
    }
    
    // MARK: Covnersion

    public func convert<NewElement>(converter: (Element -> NewElement)) -> ObservationWrapper<NewElement> {
        let nextEvent = self.event.map(converter)

        return ObservationWrapper<NewElement>(event: nextEvent, disposeBag: self.disposeBag)
    }

    /**
    Converts the observed event value to a new value by applying the `converter`
    argument.
    
    - parameter converter: The converter type to use to transform the 
    observation value.
    
    - returns: A new ObservationWrapper whose observation is the current 
    converted observation value.
    */
    public func convert<T: Converter where T.ValueType == Element>(converter: T.Type) -> ObservationWrapper<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convert(value)
        }

        return ObservationWrapper<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    /**
    Converts the observed event value to a new value by applying the `converter`
    argument.
     
    - parameter converter: The converter type to use to transform the
     observation value.
    - parameter options:   The options of the conversion.
     
    - returns: A new ObservationWrapper whose observation is the current
    converted observation value.
    */
    public func convert<T: protocol<Converter, ConverterOption> where T.ValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> ObservationWrapper<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convert(value)
        }

        return ObservationWrapper<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    /**
    Provides a reverse conversion of the event value from `ConvertValueType` to
    `ValueType`.
     
    - parameter converter: The converter type to use to transform the
    observation value.
     
    - returns: A new ObservationWrapper whose observation is the current
    converted observation value.
    */
    public func convertBack<T: ConverterReverse where T.ConvertValueType == Element>(converter: T.Type) -> ObservationWrapper<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convertBack(value)
        }

        return ObservationWrapper<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    /**
    Provides a reverse conversion of the event value from `ConvertValueType` to
    `ValueType`.
     
    - parameter converter: The converter type to use to transform the
    observation value.
    - parameter options:   The options of the conversion.
     
    - returns: A new ObservationWrapper whose observation is the current
    converted observation value.
    */
    public func convertBack<T: protocol<ConverterReverse, ConverterOption> where T.ConvertValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> ObservationWrapper<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convertBack(value)
        }

        return ObservationWrapper<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }
    
    // MARK: Callbacks

    /**
    Provides a callback invoked at the moment of the binding.
    The callback receives the events which still are in the buffer.
     
    - parameter bind: The callback closure called at the moment of the binding.
    */
    private func onBind(bind: Element? -> Void) {
        let disposable = self.event.observe { value in
            bind(value)
        }

        self.disposeBag.addDisposable(BondDisposeAdapter(disposable))
    }
}

extension ObservationWrapper where E : OptionalType {

    func convert<T: Converter where Element.WrappedType == T.ValueType>(converter: T.Type) -> ObservationWrapper<T.ConvertValueType?> {
        let nextEvent = self.event.map { (value:Element) -> T.ConvertValueType? in
            return value.isNil ? nil : converter.init().convert(value.value!)
        }

        return ObservationWrapper<T.ConvertValueType?>(event: nextEvent, disposeBag: self.disposeBag)
    }

    func convert<T: Converter where Element.WrappedType == T.ValueType, T.ConvertValueType: OptionalType>(converter: T.Type) -> ObservationWrapper<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) -> T.ConvertValueType in
            return value.isNil
                ? T.ConvertValueType(optional: nil)
                : converter.init().convert(value.value!)
        }

        return ObservationWrapper<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

}

extension ObservationWrapper : Dispose {
    public func dispose() {
        self.disposeBag.dispose()
    }
}