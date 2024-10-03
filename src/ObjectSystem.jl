module ObjectSystem
    include("./Data/DataModule.jl")
    include("./PreMacroUsageDefinitions/PreMacroUsageDefinitionsModule.jl")
    include("./InstantiationProtocol/InstantiationProtocolModule.jl")
    include("./Macros/MacrosModule.jl")
    include("FunctionCall.jl")
    include("./JOSPreDefinitions/JOSPreDefinitionsModule.jl")
end
