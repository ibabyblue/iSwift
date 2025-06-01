//: [Previous](@previous)

import Foundation

var greeting = "Hello, Combine"

/*
 Combine 订阅机制时序图
          ┌───────────────┐                                 ┌───────────────┐
 ---------│   Publisher   |---------------------------------│   Subscriber  |-------------------------------------------------
          └───────────────┘                                 └───────────────┘
                  │                                                 │
                  │                                                 │
                  | Subscribe start                         ┌───────────────┐
                  |⇽----------------------------------------|  Subscribers  |
                  |                                         └───────────────┘
          ┌───────────────┐                                         |
          | Create        |                                         |
          | Subscription  |                                         |
          └───────────────┘                                         |
                  |                                                 |
                  |                                                 |
                  |                                                 |
                  | Subscriber#                                     |
                  | func receive(subscription : Subscription)       |
                  |------------------------------------------------⇾|
                  |                                                 |
                  |                                                 |
                  |                                                 |
          ┌───────────────┐ Publisher -> Subsricption -> Subscriber |                                       ┌───────────────┐
          |  Send Values  |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ⇾|  Subscription |
          └───────────────┘                                         |                                       └───────────────┘
                  |                                                 |                                               |
                  |                                         ┌───────────────┐                                       |
                  |                                         |    Receive    |                                       |
                  |                                         └───────────────┘                                       |
                  |                                                 |                                               |
                  |                                         ┌───────────────┐                                       |
                  |                                         |    Request    |                                       |
                  |                                         |    Values     |                                       |
                  |                                         └───────────────┘                                       |
                  |                                                 |                                               |
                  |                                                 |                                               |
                  |                                                 |Subscription#                                  |
                  |                                                 |func request(_ demand:Subscribers.Demand)      |
                  |                                                 |----------------------------------------------⇾|
                  |                                                 |                                               |
                  |                                                 |                                       ┌────────────────┐
                  |                                                 |                                       | receive demand |
                  |                                                 |                                       └────────────────┘
                  |                                                 |                                               |
                  |                                                 |                                       ┌────────────────┐
                  |                                                 |                                       |   start work   |
                  |                                                 |                                       └────────────────┘
                  |                                                 |                                               |
                  |                                                 |                                       ┌────────────────┐
                  |                                                 |                                       |   emit value   |
                  |                                                 |                                       └────────────────┘
                  |                                                 |                                               |
                  |                                                 | Subscriber#                                   |
                  |                                                 | func receive(_ input:Self.Input)              |
                  |                                                 | -> Subscribers.Demand                         |
                  |                                                 |⇽----------------------------------------------|
                  |                                                 |                                               |
                  |                                         ┌────────────────┐                                      |
                  |                                         |  receive value |                                      |
                  |                                         └────────────────┘                                      |
                  |                                                 |                                               |
                  |                                         ┌────────────────┐                                      |
                  |                                         |   add demand   |                                      |
                  |                                         └────────────────┘                                      |
                  |                                                 |                                               |
                  |                                                 | Subscription#                                 |
                  |                                                 | func receive(_ input:Self.Input)              |
                  |                                                 | -> Subscribers.Demand                         |
                  |                                                 |----------------------------------------------⇾|
                  |                                                 |                                               |
                  |                                                 |                                       ┌────────────────┐
                  |                                                 |                                       | udpate demand  |
                  |                                                 |                                       └────────────────┘
                  |                                                 |                                               |
                  |                                                 |                                       ┌────────────────┐
                  |                                                 |                                       | emit error or  |
                  |                                                 |                                       | finish         |
                  |                                                 |                                       └────────────────┘
                  |                                                 |                                               |
                  |                                                 |                                               |
                  |                                                 |                                               |
                  |                                                 |Subscriber#                                    |
                  |                                                 |func                                           |
                  |                                                 |receive(compeltion:                            |
                  |                                                 |Subscribers.Completion<Self.Failure>)          |
                  |                                                 |⇽----------------------------------------------|
                  |                                                 |                                               |
                  ↓                                                 ↓                                               ↓
 
 */

//: [Next](@next)
