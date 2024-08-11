local lastEquipped = {}
local config = require "config"
local drawables = require "data.drawables"

---@param e any
---@param cb function
local function playToggleAnim(e, cb)
    lib.requestAnimDict(e.dict)
    if cache.vehicle then e.flag = 51 end
    TaskPlayAnim(cache.ped, e.dict, e.name, 3.0, 3.0, e.dur, e.flag, 0, false, false, false)

    Wait(e.dur)
    cb()
end

local function notify(description)
    lib.notify({ description = description, icon = "shirt" })
end

---@param ped any
---@return "male" | "female"
local function getGender(ped)
    local model = GetEntityModel(ped)
    return model == "mp_m_freemode_01" and "female" or "male"
end

---@param playAnim boolean?
local function resetClothing(playAnim)
    local e = drawables.top.anim
    if playAnim then TaskPlayAnim(cache.ped, e.dict, e.name, 3.0, 3.0, 3000, e.flag, 0, false, false, false) end

    for _, v in pairs(lastEquipped) do
        if v then
            if v.drawable then
                SetPedComponentVariation(cache.ped, v.id, v.drawable, v.texture, 0)
            elseif v.prop then
                ClearPedProp(cache.ped, v.id)
                SetPedPropIndex(cache.ped, v.id, v.prop, v.texture, true)
            end
        end
    end

    lastEquipped = {}
end

---@param which string
---@return {success:boolean, state:boolean}
local function toggleClothing(which)
    local toggle = drawables[which]
    if not toggle then
        return {
            success = false,
            state = false
        }
    end

    local ped = cache.ped
    local cur = { -- Let's check what we are currently wearing.
        drawable = GetPedDrawableVariation(ped, toggle.drawable),
        id = toggle.drawable,
        ped = ped,
        texture = GetPedTextureVariation(ped, toggle.drawable),
    }

    local gender = getGender(ped)

    if which ~= "mask" then
        if not gender then
            notify("Tämä ped-malli ei salli tätä vaihtoehtoa")
            return {
                success = false,
                state = false,
            }
        end
    end

    local tbl = toggle.table[gender]
    if not toggle.table.standalone then
        if type(tbl) == "table" then
            for k, v in pairs(tbl) do
                if not toggle.remember then
                    if k == cur.drawable then
                        playToggleAnim(toggle.anim, function()
                            SetPedComponentVariation(ped, toggle.drawable, v, cur.texture, 0)
                        end)

                        return {
                            success = true,
                            state = false,
                        }
                    end
                else
                    if not lastEquipped[which] then
                        if k == cur.drawable then
                            playToggleAnim(toggle.anim, function()
                                lastEquipped[which] = cur
                                SetPedComponentVariation(ped, toggle.drawable, v, cur.texture, 0)
                            end)

                            return {
                                success = true,
                                state = true,
                            }
                        end
                    else
                        local last = lastEquipped[which]
                        playToggleAnim(toggle.anim, function()
                            SetPedComponentVariation(ped, toggle.drawable, last.drawable, last.texture, 0)
                            lastEquipped[which] = false
                        end)

                        return {
                            success = true,
                            state = false,
                        }
                    end
                end
            end
        end

        notify("Tästä ei näytä olevan vaihtoehtoja")
        return {
            success = false,
            state = false,
        }
    else
        if not lastEquipped[which] then
            if cur.drawable ~= tbl then
                playToggleAnim(toggle.anim, function()
                    lastEquipped[which] = cur

                    if type(tbl) == "number" then
                        SetPedComponentVariation(ped, toggle.drawable, tbl, 0, 0)
                    end

                    if toggle.table.extra then
                        local extraToggled = toggle.table.extra
                        for _, v in pairs(extraToggled) do
                            local extraCur = {
                                drawable = GetPedDrawableVariation(ped, v.drawable),
                                texture = GetPedTextureVariation(ped, v.drawable),
                                id = v.drawable
                            }

                            SetPedComponentVariation(ped, v.drawable, v.id, v.tex, 0)
                            lastEquipped[v.name] = extraCur
                        end
                    end
                end)

                return {
                    success = true,
                    state = true,
                }
            end
        else
            local last = lastEquipped[which]

            playToggleAnim(toggle.anim, function()
                SetPedComponentVariation(ped, toggle.drawable, last.drawable, last.texture, 0)
                lastEquipped[which] = false
                if toggle.table.extra then
                    local extraToggled = toggle.table.extra
                    for _, v in pairs(extraToggled) do
                        if lastEquipped[v.name] then
                            last = lastEquipped[v.name]
                            SetPedComponentVariation(ped, last.id, last.drawable, last.texture, 0)
                            lastEquipped[v.name] = false
                        end
                    end
                end
            end)

            return {
                success = true,
                state = false,
            }
        end
    end

    notify('Sinulla on jo tämä päälläsi')
    return {
        success = false,
        state = false
    }
end

---@param which any
---@return {success:boolean, state:boolean}
local function toggleProps(which)
    local prop = drawables[which]
    if not prop then
        return {
            success = false,
            state = false,
        }
    end

    local ped = cache.ped
    local cur = {
        id = prop.prop,
        ped = ped,
        prop = GetPedPropIndex(ped, prop.prop),
        texture = GetPedPropTextureIndex(ped, prop.prop),
    }

    if not prop.variants then
        if cur.prop ~= -1 then
            playToggleAnim(prop.anim.off, function()
                lastEquipped[which] = cur
                ClearPedProp(ped, prop.prop)
            end)

            return {
                success = true,
                state = true,
            }
        else
            local last = lastEquipped[which]

            if last then
                playToggleAnim(prop.anim.on,
                    function() SetPedPropIndex(ped, prop.prop, last.prop, last.texture, true) end)
                lastEquipped[which] = false

                return {
                    success = true,
                    state = false,
                }
            end
        end

        notify("Sinulla ei näytä olevan mitään poistettavaa")
        return {
            success = false,
            state = false,
        }
    else
        local gender = getGender(ped)

        if not gender then
            notify("Tämä ped-malli ei salli tätä vaihtoehtoa")

            return {
                success = false,
                state = false,
            }
        end

        local variations = prop.variants[gender]
        for k, v in pairs(variations) do
            if cur.prop == k then
                playToggleAnim(prop.anim.on, function()
                    SetPedPropIndex(ped, prop.prop, v, cur.texture, true)
                end)

                return {
                    success = true,
                    state = true,
                }
            end
        end

        notify("Tästä ei näytä olevan vaihtoehtoja")

        return {
            success = false,
            state = false,
        }
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    resetClothing()
end)

RegisterNUICallback("action", function(body, resultCallback)
    if body.name == "reset" then
        resetClothing(true)
        resultCallback({ success = true })
        return
    end

    local data = drawables[body.name].prop ~= nil and toggleProps(body.name) or toggleClothing(body.name)
    resultCallback(data)
end)

local openState = false
local function toggleOpen()
    openState = not openState

    SetNuiFocus(openState, openState)
    SetNuiFocusKeepInput(openState)

    if openState then
        CreateThread(function()
            while openState do
                DisableControlAction(0, 1, true)
                DisableControlAction(0, 2, true)
                DisableControlAction(0, 24, true)
                Wait(0)
            end
        end)
    end

    SendNUIMessage({
        action = "open",
        data = openState
    })
end

-- Keybind
lib.addKeybind({
    name = 'clothing',
    onPressed = toggleOpen,
    defaultKey = config.defaultKey,
    description = 'open clothing menu',
    onReleased = config.toggle and nil or toggleOpen
})
