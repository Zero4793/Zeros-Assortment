--- STEAMODDED HEADER
--- MOD_NAME: Zeros Decks
--- MOD_ID: zeros_decks
--- MOD_AUTHOR: [Zero_4793]
--- MOD_DESCRIPTION: Antimatter Deck.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

----------------------------------------------
------------MOD CODE -------------------------

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
			"Have 8 {C:attention}Jokers at run win"
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

----------------------------------------------
------------MOD CODE END----------------------
