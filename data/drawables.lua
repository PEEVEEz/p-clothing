local variations = require "data.variations"

return {
    ["top"] = {
        drawable = 11,
        table = variations.jackets,
        anim = { dict = "missmic4", name = "michael_tux_fidget", flag = 51, dur = 1500 }
    },
    ["gloves"] = {
        drawable = 3,
        table = variations.gloves,
        remember = true,
        anim = { dict = "nmt_3_rcm-10", name = "cs_nigel_dual-10", flag = 51, dur = 1200 }
    },
    ["shoes"] = {
        drawable = 6,
        table = { standalone = true, male = 34, female = 35 },
        anim = { dict = "random@domestic", name = "pickup_low", flag = 0, dur = 1200 }
    },
    ["neck"] = {
        drawable = 7,
        table = { standalone = true, male = 0, female = 0 },
        anim = { dict = "clothingtie", name = "try_tie_positive_a", flag = 51, dur = 2100 }
    },
    ["vest"] = {
        drawable = 9,
        table = { standalone = true, male = 0, female = 0 },
        anim = { dict = "clothingtie", name = "try_tie_negative_a", flag = 51, dur = 1200 }
    },
    ["bag"] = {
        drawable = 5,
        table = variations.bags,
        anim = { dict = "anim@heists@ornate_bank@grab_cash", name = "intro", flag = 51, dur = 1600 }
    },
    ["mask"] = {
        drawable = 1,
        table = { standalone = true, male = 0, female = 0 },
        anim = { dict = "mp_masks@standard_car@ds@", name = "put_on_mask", flag = 51, dur = 800 }
    },
    ["hair"] = {
        drawable = 2,
        table = variations.hair,
        remember = true,
        anim = { dict = "clothingtie", name = "check_out_a", flag = 51, dur = 2000 }
    },
    ["shirt"] = {
        drawable = 11,
        table = {
            standalone = true,
            male = 252,
            female = 74,
            extra = {
                { drawable = 8,  id = 15, tex = 0, name = "extra undershirt" },
                { drawable = 3,  id = 15, tex = 0, name = "extra gloves" },
                { drawable = 10, id = 0,  tex = 0, name = "extra decals" },
            }
        },
        anim = { dict = "clothingtie", name = "try_tie_negative_a", flag = 51, dur = 1200 }
    },
    ["pants"] = {
        drawable = 4,
        table = { standalone = true, male = 61, female = 14 },
        anim = { dict = "re@construction", name = "out_of_breath", flag = 51, dur = 1300 }
    },
    ["visor"] = {
        prop = 0,
        variants = variations.visor,
        anim = {
            on = { dict = "mp_masks@standard_car@ds@", name = "put_on_mask", flag = 51, dur = 600 },
            off = { dict = "missheist_agency2ahelmet", name = "take_off_helmet_stand", flag = 51, dur = 1200 }
        }
    },
    ["hat"] = {
        prop = 0,
        anim = {
            on = { dict = "mp_masks@standard_car@ds@", name = "put_on_mask", flag = 51, dur = 600 },
            off = { dict = "missheist_agency2ahelmet", name = "take_off_helmet_stand", flag = 51, dur = 1200 }
        }
    },
    ["glasses"] = {
        prop = 1,
        anim = {
            on = { dict = "clothingspecs", name = "take_off", flag = 51, dur = 1400 },
            off = { dict = "clothingspecs", name = "take_off", flag = 51, dur = 1400 }
        }
    },
    ["ear"] = {
        prop = 2,
        anim = {
            on = { dict = "mp_cp_stolen_tut", name = "b_think", flag = 51, dur = 900 },
            off = { dict = "mp_cp_stolen_tut", name = "b_think", flag = 51, dur = 900 }
        }
    },
    ["watch"] = {
        prop = 6,
        anim = {
            on = { dict = "nmt_3_rcm-10", name = "cs_nigel_dual-10", flag = 51, dur = 1200 },
            off = { dict = "nmt_3_rcm-10", name = "cs_nigel_dual-10", flag = 51, dur = 1200 }
        }
    },
    ["bracelet"] = {
        prop = 7,
        anim = {
            on = { dict = "nmt_3_rcm-10", name = "cs_nigel_dual-10", flag = 51, dur = 1200 },
            off = { dict = "nmt_3_rcm-10", name = "cs_nigel_dual-10", flag = 51, dur = 1200 }
        }
    },
}
