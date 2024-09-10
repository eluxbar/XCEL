cfg = {}

cfg.settings = {
    wagerStartLoc = vector3(93.241691589355,6357.61328125,31.375856399536),
    wagerBetAmount = 100000,
    wagerMinBet = 100000,
    wagerMaxBet = 100000000,
    categoryIndex = 1,
    -- wagerOpenTime = 13,
    -- wagerCloseTime = 21,
    maxTeamPlayers = 2,
    ["categories"] = {
        "Pistols",
        "Shotguns",
        "SMGs",
        "Assault Rifles",
        "Snipers",
    },
    weaponInCategoryIndex = 1,
    ["weapons_in_category"] = {
        ["Pistols"] = {
            ["WEAPON_M1911"] = "",
            ["WEAPON_ROOK"] = "",
            ["WEAPON_TEC9"] = "",
            --["WEAPON_REVOLVER357"] = "",
        },
        ["Shotguns"] = {
            ["WEAPON_OLYMPIA"] = "",
            ["WEAPON_SPAZ"] = "",
            ["WEAPON_WINCHESTER12"] = "",
        },
        ["SMGs"] = {
            ["WEAPON_SCORPIONBLUE"] = "",
            ["WEAPON_UMP45"] = "",
            ["WEAPON_UZI"] = "",
        },
        ["Assault Rifles"] = {
            ["WEAPON_GOLDAK"] = "",
            ["WEAPON_AK200"] = "",
          --  ["WEAPON_AK74"] = "",
            ["WEAPON_AKM"] = "",
            ["WEAPON_SPAR17"] = "",
            ["WEAPON_MXM"] = "",
            --["WEAPON_MK1EMR"] = "",
        },
        ["Snipers"] = {
            ["WEAPON_MOSIN"] = "",
            ["WEAPON_M82BLOSSOM"] = "",
            ["WEAPON_MK14"] = "",
        },
    },
    armour_index = 1,
    ["armour_values"] = {
        "0%",
        "25%",
        "50%",
        "75%",
        "100%",
    },
    best_ofIndex = 1,
    ["best_of"] = {
        "1",
        "3",
        "5",
    },
    locationIndex = 1,
    ["locations"] = {
        ["shipment"] = "Shipment",
        ["rooftop"] = "Roof Top",
        -- ["hijacked"] = "Hijacked",
        ["oil_rig"] = "Oil Rig",
        ["paintball"] = "Paintball Arena",
        ["heroin"] = "Heroin",
        ["large_arms"] = "Large Arms",
        -- ["nuketown"] = "Nuketown",
    },
    ["location_coords"] = {
        -- {load_IPL = true} if the map requires an IPL to be loaded
        ["hijacked"] = {
            A = {
                vector3(-5297.6689453125,-577.87677001953,7.6418790817261), -- 1
                vector3(-5274.5834960938,-569.7763671875,7.6419062614441) -- 2
            },
            B = {
                vector3(-5309.3720703125,-545.24749755859,9.1057329177856), -- 1
                vector3(-5286.81640625,-537.56903076172,9.1058320999146) -- 2
            },
            --load_IPL = true,
            radius = 85.0
        },
        ["shipment"] = {
            A = {
                vector3(1106.4350585938,-2876.6147460938,7.0450010299683), -- 1
                vector3(1104.4666748047,-2874.2277832031,7.0450010299683) -- 2
            },
            B = {
                vector3(1139.7330322266,-2836.0561523438,7.0450372695923), -- 1
                vector3(1138.234375,-2834.4482421875,7.0450353622437) -- 2
            },
            --load_IPL = true,
            radius = 50.0
        },
        ["rooftop"] = {
            A = {
                vector3(-56.627361297607,177.79515075684,140.1782989502), -- 1
                vector3(-53.6552734375,179.86079406738,140.17839050293) -- 2
            },
            B = {
                vector3(-34.070983886719,152.03785705566,140.17835998535), -- 1
                vector3(-37.262603759766,150.19438171387,140.17842102051) -- 2
            },
            radius = 50.0
        },
        ["oil_rig"] = {
            A = {
                vector3(-1689.9057617188,8885.61328125,26.360071182251), -- 1
                vector3(-1692.0286865234,8884.3779296875,26.360071182251) -- 2
            },
            B = {
                vector3(-1716.4625244141,8877.775390625,18.859910964966), -- 1
                vector3(-1717.3388671875,8875.8916015625,18.874937057495) -- 2
            },
            radius = 60.0
        },
        ["paintball"] = {
            A = {
                vector3(2032.6206054688,2849.0546875,49.13716506958), -- 1
                vector3(2020.7788085938,2855.197265625,49.206661224365) -- 2
            },
            B = {
                vector3(2011.2452392578,2714.6345214844,48.862300872803), -- 1
                vector3(2022.1726074219,2711.7236328125,49.19649887085) -- 2
            },
            radius = 150.0
        },
        ["heroin"] = {
            A = {
                vector3(3622.259521, 3707.805908, 34.066059), -- 1
                vector3(3620.4072265625,3704.0961914063,34.066028594971) -- 2
            },
            B = {
                vector3(3445.039307, 3773.092529, 29.520403), -- 1
                vector3(3444.4301757813,3770.3422851563,29.526519775391) -- 2
            },
            radius = 190.0
        },
        ["large_arms"] = {
            A = {
                vector3(-1159.465942, 4925.105469, 221.721100), -- 1
                vector3(-1159.5999755859,4922.7470703125,221.5313873291) -- 2
            },
            B = {
                vector3(-1049.638794, 4920.305664, 208.682175), -- 1
                vector3(-1050.3145751953,4917.5493164063,208.89889526367) -- 2
            },
            radius = 165.0
        },
        -- ["nuketown"] = {A = vector3(2385.467529, 3272.613281, 92.353539), B = vector3(2463.409424, 3261.223389, 92.353394), load_IPL = true},
    }
}

return cfg