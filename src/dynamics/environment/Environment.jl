module Environment
    using ..Landscapes
    using ..MetacommunityDynamics

    struct EnvironmentalMeasurement
        dimensions::Int
        time::Number
        value::Vector{Number}
    end
    export EnvironmentalMeasurement

    struct EnvironmentalMeasurementSet end

    export EnvironmentalMeasurementSet

    struct EnvironmentModel
        locations::LocationSet
        measurements::EnvironmentalMeasurementSet
    end

        EnvironmentModel(;  locations::LocationSet = LocationSet(), environment = EnvironmentalMeasurementSet()) = EnvironmentModel(locations, environment)
    export EnvironmentModel
end
