# Development of Julia Object System

A Document to register features that I still need to implement, plus, if I need to, logs for my development logic

## What needs doing

- [x] 2.0 Macros
  - [x] 2.0.1 defclass
  - [x] 2.0.2 defgeneric
  - [x] 2.0.3 defmethod
  - [x] 2.0.4 defbuiltin
- [x] 2.1 Classes
- [x] 2.2 Instances
- [x] 2.3 Slot Access
- [x] 2.4 Generic Functions and methods
- [x] 2.5 Pre-defined Generic Functions and Methods
- [x] 2.6 MetaObjects
- [x] 2.7 Class Options
- [x] 2.8 Readers and Writers
- [x] 2.9 Generic Function Calls
- [x] 2.10 Multiple Dispatch
- [x] 2.11 Multiple Inheritance
- [x] 2.12 Class Hierarchy
- [x] 2.13 Class Precedence List
- [x] 2.14 Built-In Classes
- [x] 2.15 Introspection
- [x] 2.16 Meta-Object Protocols
- [x] 2.16.1 Class Instantiation Protocol
- [x] 2.16.2 The Compute Slots Protocol
- [x] 2.16.3 Slot Access Protocol
- [x] 2.16.4 Class Precedence List protocol
- [x] 2.17 Multiple Meta-Class Inheritance
- [ ] 2.18 Extensions
  - [ ] 2.18.1 Meta-Objects for slot definitions
  - [ ] 2.18.2 CLOS-like method combination for generic functions
  - [ ] 2.18.3 CLOS or Dylan's strategy for computing the class precedence list
  - [ ] 2.18.4 Additional Metaobject protocols
- [x] Make `check_polymorphism` and `check_class` a JOS method
- [x] Make `is_class`
- [x] Make `non-applicable-method` predefined
- [x] If generic function does not exist when method created, auto generate it
- [x] Compute class precedence list
- [x] Compute slots
- [x] Refactor so that defclass uses instantiation protocol
- [x] Refactor so that defgeneric uses instantiation protocol
- [x] Refactor so that defmethod uses instantiation protocol
- [ ] Add support for unions
- [ ] Add call previous method
- [ ] Improve how comparisons between slots is made so that I dont need to override hash
- [ ] Check and Improve introspection assertions
- [ ] Ability to call new without naming properties (in order?)
- [ ] Create a Julia library?
- [ ] Replace `getfield(o, :class_of_reference)` with `class_of(o)`
- [ ] Solve warning on running tests "Warning: Assignment to `Person` in soft scope is ambiguous because a global variable by the same name exists: `Person` will be treated as a new local. Disambiguate by using `local Person` to suppress this warning or `global Person` to assign to the existing global variable."
- [ ] Update branch protection
- [ ] Uniformize naming conventions
