# Development of Julia Object System

A Document to register features that I still need to implement, plus, if I need to, logs for my development logic

## What needs doing

- [ ] 2.0 Macros
  - [x] 2.0.1 defclass [Not complete yet]
    - [ ] 2.0.1 Complete defclass
  - [x] 2.0.2 defgeneric
  - [x] 2.0.3 defmethod
  - [ ] 2.0.4 defbuiltin
- [x] 2.1 Classes
- [ ] 2.2 Instances
- [ ] 2.3 Slot Access
- [x] 2.4 Generic Functions and methods
- [ ] 2.5 Pre-defined Generic Functions and Methods
- [ ] 2.6 MetaObjects
- [ ] 2.7 Class Options
- [ ] 2.8 Readers and Writers
- [ ] 2.9 Generic Function Calls
- [ ] 2.10 Multiple Dispatch
- [ ] 2.11 Multiple Inheritance - Juliana Testes
- [ ] 2.12 Class Hierarchy
- [ ] 2.13 Class Precedence List
- [ ] 2.14 Built-In Classes
- [ ] 2.15 Introspection
- [ ] 2.16 Meta-Object Protocols
- [ ] 2.16.1 Class Instantiation Protocol - Juliana
- [ ] 2.16.2 The Compute Slots Protocol
- [ ] 2.16.3 Slot Access Protocol
- [ ] 2.16.4 Class Precedence List protocol
- [ ] 2.17 Multiple Meta-Class Inheritance - Liliana Testes
- [ ] 2.18 Extensions
  - [ ] 2.18.1 Meta-Objects for slot definitions
  - [ ] 2.18.2 CLOS-like method combination for generic functions
  - [ ] 2.18.3 CLOS or Dylan's strategy for computing the class precedence list
  - [ ] 2.18.4 Additional Metaobject protocols
- [ ] Make `check_polymorphism` and `check_class` a JOS method
- [ ] Make `is_class`
- [ ] Make `non-applicable-method` predefined
- [x] If generic function does not exist when method created, auto generate it
