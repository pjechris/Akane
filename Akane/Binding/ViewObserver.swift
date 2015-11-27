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
 Provide a minimalistic API tailored for observing a ```Observation``` from a view.

 The restricted access is the intended goal of this class: if you're not able to do what you want then it means your
 to either refactor your code or write it somewhere else.

 It wraps a ```Observation``` object on which you have (limited) access through different methods:
 - convert/convertBack, to transform the observation value into a new one
 - bindTo, to link the observation value with a view field/attribute

*/
public class ViewObserver<E> {
    public typealias Element = E

    public private(set) var value: E!

    internal let event: EventProducer<E>
    private let disposeBag: DisposeBag

    internal convenience init<T:Observation where T.Element == E>(observable:T, disposeBag: DisposeBag) {
        let internalObservable = Bond.Observable<E>(observable.value)

        disposeBag.addDisposable(
            observable.observe { [unowned internalObservable] value in
                internalObservable.next(value)
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

    /// Bind the observation value to a bindable class
    /// @param bindable the bindable item. Should be a view attribute, like a label text attribute.
    public func bindTo<T: Bindable where T.Element == Element>(bindable: T) {
        let next = bindable.advance()
        let disposable = self.event.observe { value in
            next(value)
        }

        self.disposeBag.addDisposable(BondDisposeAdapter(disposable))
    }

    public func combine<T: Observation>(observables: T...) -> Self {
        return self
    }

    /// Convert the observation value into a new value by applying the argument converter
    /// @param converter the converter type to use to transform the observation value
    /// @returns a new ViewObserver whose observation is the current converted observation value
    public func convert<T: Converter where T.ValueType == Element>(converter: T.Type) -> ViewObserver<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convert(value)
        }

        return ViewObserver<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    public func convert<T: protocol<Converter, ConverterOption> where T.ValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> ViewObserver<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convert(value)
        }

        return ViewObserver<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    public func convertBack<T: ConverterReverse where T.ConvertValueType == Element>(converter: T.Type) -> ViewObserver<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convertBack(value)
        }

        return ViewObserver<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    public func convertBack<T: protocol<ConverterReverse, ConverterOption> where T.ConvertValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> ViewObserver<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convertBack(value)
        }

        return ViewObserver<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }
}