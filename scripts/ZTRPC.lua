-- Includes:
include "scenario/scripts/entity.lua"
include "scenario/scripts/token.lua"
include "scenario/scripts/ui.lua"
include "scenario/scripts/misc.lua"

local discordRPC = require("discordRPC")

local appId = require("applicationId")

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end

function ztRPC(args)
    local gameMgr = queryObject("BFGManager")
    if gameMgr ~= nil then
        local animalList = findType("animal")
        if animalList ~= nil and type(animalList) == "table" then
            local numAnimal = table.getn(animalList)
            for i = 1, numAnimal, 1 do
                local animal = resolveTable(animalList[i].value)
                if animal ~= nil then
                    local name = animal:BFG_GET_ATTR_STRING("s_name")
                    if (name == "Yeet") then
                        animal:BFG_SET_ATTR_STRING("s_name", "Henk")
                        discordRPC.initialize(appId, true)
                        local now = os.time(os.date("*t"))
                        presence = {
                            state = "Playing Zoo Tycoon",
                            details = "1v1 (Ranked)",
                            startTimestamp = now,
                            endTimestamp = now + 60,
                            partyId = "party id",
                            partyMax = 2,
                            matchSecret = "match secret",
                            joinSecret = "join secret",
                            spectateSecret = "spectate secret",
                        }

                        nextPresenceUpdate = 0
                    elseif (name == "Henk") then
                        animal:BFG_SET_ATTR_STRING("s_name", "Joost")
                        if nextPresenceUpdate < love.timer.getTime() then
                            discordRPC.updatePresence(presence)
                            nextPresenceUpdate = love.timer.getTime() + 2.0
                        end
                        discordRPC.runCallbacks()
                    end
                end
            end
        end
    end
end
