Config = {}

Config.RepairTime = 5  -- Seconds

Config.CostFactor = 0.5  -- Determines overall cost of all repairs less than 1 = cheeper more than 1 = higher price

Config.ClassRepairMultiplier = {
    -- Determines how much more or less a repair will cost based on class less than 1 cheeper more than 1 higher price
    [0] = 1.0,  -- Compacts
    [1] = 1.0,  -- Sedans
    [2] = 1.0,  -- SUVs
    [3] = 1.0,  -- Coupes
    [4] = 1.0,  -- Muscle
    [5] = 1.7,  -- Sports Classics
    [6] = 1.8,  -- Sports
    [7] = 2.0,  -- Super
    [8] = 1.0,  -- Motorcycles
    [9] = 1.0,  -- Off-road
    [10] = 1.0, -- Industrial
    [11] = 1.0, -- Utility
    [12] = 1.0, -- Vans
    [13] = 1.0, -- Cylces
    [14] = 1.0, -- Boats
    [15] = 1.0, -- Helicopters
    [16] = 1.0, -- Planes
    [17] = 1.0, -- Service
    [18] = 0.1, -- Emergency
    [19] = 1.0, -- Military
    [20] = 1.0, -- Commercial
    [21] = 0    -- Trains
}

Config.RepairShops = {
    {
        label = "Mirror Park Repair", 
        zone = {name = 'MirrorParkRepair', x = 1145.3, y = -778.4, z = 57.6, l = 30.0, w = 20.0, h = 90, minZ = 55, maxZ = 60}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },

    {
        label = "South Side Atomic Repair", 
        zone = {name = 'SouthSideAtomicRepair', x = 481.5, y = -1889.6, z = 26.1, l = 15.0, w = 15.0, h = 25, minZ = 23, maxZ = 29}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },

    {
        label = "Auto Exotic Repair", 
        zone = {name = 'AutoExoticRepair', x = 537, y = -180.6, z = 54.3, l = 22.8, w = 16.2, h = 0, minZ = 52, maxZ = 56}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },

    {
        label = "Flywheels Repair", 
        zone = {name = 'FlywheelsRepairShop', x = 1774.9, y = 3333.6, z = 41.3, l = 20.0, w = 15.0, h = 300, minZ = 40, maxZ = 44}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },

    {
        label = "Paleto Repair", 
        zone = {name = 'PaletoRepair', x = 24.7, y = 6460.9, z = 31.4, l = 20.0, w = 25.0, h = 315, minZ = 30, maxZ = 35}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },

    {
        label = "Autopia Parkway Repair", 
        zone = {name = 'AutopiaParkwayRepair', x = -441.9, y = -2174.0, z = 10.3, l = 21.4, w = 20.0, h = 0, minZ = 9, maxZ = 14}, 
        blip = {
            scale = 0.7,
            sprite = 72,
            colour = 0
        },
    },
    --[[
        TEMPLATE:
        {
            label = "", 
            zone = {name = 'A name', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, 
            blip = {
                scale = 0.7,
                sprite = 72,
                colour = 0
            },
        },
    ]]
}