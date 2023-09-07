using JuliaObjectSystem

a = SlotDefinition(:a, 1)
b = SlotDefinition(:a, 2)

a == b
isequal(a, b)
isequal(b, a)
unique([a, a])
unique([a, b])
allunique([a, a])
