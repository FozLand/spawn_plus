-- randomize player position within the spawn plot
local function go_spawn(player)
	if core.setting_get('static_spawnpoint') then
		local pos = core.setting_get_pos('static_spawnpoint')
		if core.setting_get('variable_spawnpoint') then
			local range = tonumber(core.setting_get('variable_spawnpoint'))
			if range > 0 then
				pos.x = pos.x + math.random(-(range), range)
				pos.z = pos.z + math.random(-(range), range)
				core.log("action", '[Spawn Plus] Moving player to pos '..pos.x..', '..pos.y)
			end
		end
		player:setpos( pos )
	end
end

core.register_chatcommand('spawn', {
	description = "Teleports you to spawn",
	privs = {
		shout = true
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play("teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		go_spawn(player)
	end
})

core.register_chatcommand('arena', {
	description = "Teleports you to PVP arena",
	privs = {
		shout = true,
		interact = true
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=595, y=6, z=405 } )
	end
})

local function find_free(pos)
	for _, d in ipairs(tries) do
		local p = {x = pos.x+d.x, y = pos.y+d.y, z = pos.z+d.z}
		local n = core.get_node(p)
		if not core.registered_nodes[n.name].walkable then
			return p, true
		end
	end
end

local INTERVAL=3
local LIMIT=4500
local function check_pos_range()
	for _,p in ipairs(core.get_connected_players()) do
		local pos = p:getpos()
		-- map limit
		if math.abs(pos.x) > LIMIT or math.abs(pos.z) > LIMIT then
			core.chat_send_player(
				p:get_player_name(),
				'Sorry, but you should not go beyond '..tostring(LIMIT)..'.'
			)
			p:set_hp( p:get_hp() - 2 )
			go_spawn(p)
		end
	end
	core.after(INTERVAL, check_pos_range)
end

core.after(INTERVAL, check_pos_range)
