//
// This file is part of Akane
//
// Created by JC on 01/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

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