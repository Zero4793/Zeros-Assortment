--- STEAMODDED HEADER
--- MOD_NAME: Zeros Decks
--- MOD_ID: zeros_decks
--- MOD_AUTHOR: [Zero_4793]
--- MOD_DESCRIPTION: Antimatter Deck.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

----------------------------------------------
------------MOD CODE -------------------------

-- start with 1 joker slot, gain 1 per ante
SMODS.Back{
	key = "antimatterDeck",
	pos = {x = 1, y = 0},
	loc_txt = {
		name = "Antimatter",
		text ={
			"Start with 1 {C:attention}Joker slot",
			"Gain 1 per {C:attention}Ante."			
		},
		unlock = {
			"Have {C:attention}8 Jokers{} at run {C:attention}win"
		}
	},
	apply = function()
		G.GAME.starting_params.joker_slots = 1
	end,
	trigger_effect = function(self, args)
		if args.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
			G.jokers.config.card_limit = G.jokers.config.card_limit + 1
		end
	end,
	unlocked = false,
	discovered = false,
	-- have 8 jokers when ante up to 9
	check_for_unlock = function(self, args)
		if args.type == "ante_up" and args.ante == 9 and #G.jokers.cards >= 8 then
			unlock_card(self)
		end
	end
}

-- $25, jumbo buffoon pack, start ante 2
SMODS.Back{
	key = "Headstart",
	pos = {x = 2, y = 0},
	config = { dollars = 21	},
	loc_txt = {
		name = "Headstart",
		text = {
			"Start on {C:red}Ante 2",
			"with {C:attention}$25{} and a",
			"{C:blue}Jumbo Buffoon Pack"
		},
		unlock = {
			"Skip {C:attention}6 Blinds{} by {C:attention}Ante 4"
		}
	},
	apply = function()
		-- ante = 2
		ease_ante(1)
		G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or 2
		-- gain 1 jumbo buffoon pack
		G.E_MANAGER:add_event(Event({
			func = (function()
				add_tag(Tag("tag_buffoon"))
				return true
			end)
		}))
	end,
	unlocked = false,
	discovered = false,
	-- skip to ante 4
	check_for_unlock = function(self, args)
		if args.type == "ante_up" and args.ante == 4 and G.GAME.skips >= 6 then
			unlock_card(self)
		end
		-- if args.type == "ante_up" then
		-- 	print(args.ante)
		-- 	print(G.GAME.skips)
		-- 	-- print(args.skips_total)
		-- end
		-- if args.type == "blind_skipped" then
		-- 	-- print(args.ante)
		-- 	print(G.GAME.skips)
		-- 	print(args.skips_total)
		-- end
	end
}
--G.GAME.skips = local/run
--args.skips_total = global/profile


----------------------------------------------
------------MOD CODE END----------------------
