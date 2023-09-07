using JuliaObjectSystem

a = SlotDefinition(:a, 1)
b = SlotDefinition(:a, 2)
c = SlotDefinition(:b, 2)

symdiff([a, b, c], unique([a, b, c]))

symdiff([a], [b])

symdiff([1], [1, 1])

a == b
isequal(a, b)
isequal(b, a)
unique([a, a])
unique([a, b])
allunique([a, a])
