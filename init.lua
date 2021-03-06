-- randomize player position within the spawn plot
local function go_spawn(player)
	if core.setting_get('static_spawnpoint') then
		local pos = core.setting_get_pos('static_spawnpoint')
		if core.setting_get('variable_spawnpoint') then
			local range = tonumber(core.setting_get('variable_spawnpoint'))
			if range > 0 then
				pos.x = pos.x + math.random(-(range), range)
				pos.z = pos.z + math.random(-(range), range)
			end
		end
		local name = player:get_player_name()
		core.log("action", '[Spawn Plus] Moving '..name..' to '..
			string.format("(%0.1f, %0.1f, %0.1f)", pos.x, pos.y, pos.z)
		)
		core.sound_play("teleport", {
			to_player=name,
			gain = 0.1
		})
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

core.register_chatcommand('hall', {
	description = "Teleports you to City Hall",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=135, y=7, z=40 } )
	end
})

core.register_chatcommand('post', {
	description = "Teleports you to the Post Office",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=676, y=4, z=523 } )
	end
})

core.register_chatcommand('town', {
	description = "Teleports you to the town.",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=620, y=3, z=-2906 } )
	end
})

core.register_chatcommand('airport', {
	description = "Teleports you to the airport.",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=1395, y=33, z=-2880 } )
	end
})

core.register_chatcommand('hub', {
	description = "Teleports you to the hub.",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=1112, y=11, z=-544 } )
	end
})

core.register_chatcommand('mine', {
	description = "Teleports you to the pubic mine.",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=33, y=-72, z=235 } )
	end
})

core.register_chatcommand('mall', {
	description = "Teleports you to the mall.",
	privs = {
		shout = true,
	},
	func = function(name)
		local player = core.get_player_by_name(name)
		core.sound_play( "teleport", {
			to_player=player:get_player_name(),
			gain = 0.1
		})
		player:setpos( { x=667, y=6, z=-377 } )
	end
})

local INTERVAL=3
local WARN_LIMIT=4500
local LIMIT=4528
local function check_pos_range()
	local players = core.get_connected_players()
	for _,p in ipairs(players) do
		if p:is_player() and not core.check_player_privs(p, 'server') then
			local pos = p:getpos()
			local max = math.max(math.abs(pos.x), math.abs(pos.z))
			if max > LIMIT then
				p:set_detach()
				go_spawn(p)
				local name = p:get_player_name()
				core.chat_send_player(name, 'You won a free ticket to spawn!')
				core.after(1, function() -- kick players who won't move
					if p:is_player() then
						pos = p:getpos()
						max = math.max(math.abs(pos.x), math.abs(pos.z))
						if max > LIMIT then
							core.kick_player(name, "You are too far from spawn.")
						end
					end
				end)
			elseif max > WARN_LIMIT then
				local name = p:get_player_name()
				core.sound_play('spawnplus_sucker_punch', {to_player=name, gain = 0.2})
				p:set_hp( p:get_hp() - 4 )
				core.chat_send_player(name, 'Do not travel beyond '..WARN_LIMIT..'.')
				core.log("action", '[Spawn Plus] '..name..' out of bounds at '..
					core.pos_to_string(pos)..', hp reduced to '..p:get_hp())
			end
		end
	end
	core.after(INTERVAL, check_pos_range)
end

core.after(INTERVAL, check_pos_range)

core.register_on_joinplayer(function (player)
		local pos = player:getpos()
		local max = math.max(math.abs(pos.x),math.abs(pos.z))
		if max > LIMIT then
			go_spawn(player)
		end
end)
