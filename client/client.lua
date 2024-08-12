lib.locale()
local lastEquipped = {}
local config = require "shared.config"
local drawables = require "shared.drawables"

---@param anim unknown
---@param cb function
local function playToggleAnim(anim, cb)
    lib.requestAnimDict(anim.dict)
    if cache.vehicle then anim.flag = 51 end
    TaskPlayAnim(cache.ped, anim.dict, anim.name, 3.0, 3.0, anim.dur, anim.flag, 0, false, false, false)

    Wait((anim.dur - 500) < 500 and 500 or (anim.dur - 500))
    cb()
end

---@param key string
local function notify(key)
    lib.notify({ description = locale(key), icon = "shirt" })
end

---@return "male" | "female"
local function getGender()
    local model = GetEntityModel(cache.ped)
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

    local cur = {
        id = toggle.drawable,
        texture = GetPedTextureVariation(cache.ped, toggle.drawable),
        drawable = GetPedDrawableVariation(cache.ped, toggle.drawable),
    }

    local gender = getGender()

    if which ~= "mask" and not gender then
        notify("not_allowed_ped")

        return {
            success = false,
            state = false,
        }
    end

    local tbl = toggle.table[gender]
    if not toggle.table.standalone then
        if type(tbl) == "table" then
            for k, v in pairs(tbl) do
                if not toggle.remember then
                    if k == cur.drawable then
                        playToggleAnim(toggle.anim, function()
                            if type(v) == "number" then
                                SetPedComponentVariation(cache.ped, toggle.drawable, v, cur.texture, 0)
                            end
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
                                SetPedComponentVariation(cache.ped, toggle.drawable, v, cur.texture, 0)
                            end)

                            return {
                                success = true,
                                state = true,
                            }
                        end
                    else
                        local last = lastEquipped[which]
                        playToggleAnim(toggle.anim, function()
                            SetPedComponentVariation(cache.ped, toggle.drawable, last.drawable, last.texture, 0)
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

        notify("no_variants")
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
                        SetPedComponentVariation(cache.ped, toggle.drawable, tbl, 0, 0)
                    end

                    if toggle.table.extra then
                        local extraToggled = toggle.table.extra
                        for _, v in pairs(extraToggled) do
                            local extraCur = {
                                id = v.drawable,
                                texture = GetPedTextureVariation(cache.ped, v.drawable),
                                drawable = GetPedDrawableVariation(cache.ped, v.drawable),
                            }

                            SetPedComponentVariation(cache.ped, v.drawable, v.id, v.tex, 0)
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
                SetPedComponentVariation(cache.ped, toggle.drawable, last.drawable, last.texture, 0)
                lastEquipped[which] = false

                if toggle.table.extra then
                    local extraToggled = toggle.table.extra
                    for _, v in pairs(extraToggled) do
                        if lastEquipped[v.name] then
                            last = lastEquipped[v.name]
                            SetPedComponentVariation(cache.ped, last.id, last.drawable, last.texture, 0)
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

    notify("already_wearing")
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

    local cur = {
        id = prop.prop,
        prop = GetPedPropIndex(cache.ped, prop.prop),
        texture = GetPedPropTextureIndex(cache.ped, prop.prop),
    }

    if not prop.variants then
        if cur.prop ~= -1 then
            playToggleAnim(prop.anim.off, function()
                lastEquipped[which] = cur
                ClearPedProp(cache.ped, prop.prop)
            end)

            return {
                success = true,
                state = true,
            }
        else
            local last = lastEquipped[which]

            if last then
                playToggleAnim(prop.anim.on,
                    function() SetPedPropIndex(cache.ped, prop.prop, last.prop, last.texture, true) end)
                lastEquipped[which] = false

                return {
                    success = true,
                    state = false,
                }
            end
        end

        notify("nothing_to_remove")

        return {
            success = false,
            state = false,
        }
    else
        local gender = getGender()

        if not gender then
            notify("not_allowed_ped")

            return {
                success = false,
                state = false,
            }
        end

        local variations = prop.variants[gender]
        for k, v in pairs(variations) do
            if cur.prop == k then
                playToggleAnim(prop.anim.on, function()
                    SetPedPropIndex(cache.ped, prop.prop, v, cur.texture, true)
                end)

                return {
                    success = true,
                    state = true,
                }
            end
        end

        notify("no_variants")

        return {
            success = false,
            state = false,
        }
    end
end

---@param name string
---@param data unknown?
---@return {success:boolean, state?:boolean}
local function action(name, data)
    if name == "reset" then
        resetClothing(true)
        return { success = true }
    elseif name == "cursor" then
        if data then
            SetCursorLocation(data.x, data.y)
            return { success = true }
        end

        return { success = false }
    end


    return drawables[name].prop ~= nil
        and toggleProps(name)
        or toggleClothing(name)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    resetClothing()
end)

RegisterNUICallback("action", function(body, resultCallback)
    local result = action(body.name, body)
    resultCallback(result)
end)

local ready = false
local openState = false
local function toggleOpen()
    if not ready then
        ready = true
        SendNUIMessage({
            action = "position",
            data = config.position
        })
    end

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

lib.addKeybind({
    name = 'clothing',
    onPressed = toggleOpen,
    defaultKey = config.defaultKey,
    description = 'open clothing menu',
    onReleased = config.toggle and nil or toggleOpen
})

if config.commands then
    for name, _ in pairs(drawables) do
        local commandName = locale(("command_%s"):format(name))

        RegisterCommand(commandName, function()
            action(name)
        end, false)

        TriggerEvent('chat:addSuggestion', ("/%s"):format(commandName), locale(("%s_description"):format(commandName)),
            {})
    end
end
