T(
    "Given a value of 1",
    function(T)
        local value = 1
        T(
            "When incremented by 1",
            function(T)
                value = value + 1
                T:assert(false, "Then the value is equal to 2")
            end
        )
        T(
            "When incremented by 2",
            function(T)
                assert(value == 1) -- value is 1 again here!
                value = value + 2
                T:assert(value == 3, "Then the value is equal to 3")
            end
        )
    end
)
