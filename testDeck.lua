--- STEAMODDED HEADER
--- MOD_NAME: Test Deck
--- MOD_ID: TestDeck
--- MOD_AUTHOR: [Zero_4793]
--- MOD_DESCRIPTION: Test Deck of various mechanics.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Back{
	key = "test_deck",
	pos = {x = 1, y = 0},
	unlocked = true,
	discovered = true,
	loc_txt = {
		name = "Test Deck",
		text ={
			"Who knows what you'll get here",
			"Just a deck of random changes!"			
		},
	},
	apply = function()
		G.E_MANAGER:add_event(Event({
			func = function(self)
				for i, card in ipairs(G.playing_cards) do
					-- card.set_base(G.P_CARDS['S_A'])
					-- card.set_ability(G.P_CENTERS.m_lucky)
					-- card.set_edition({polychrome = nil}, true, true)
					-- card.set_seal('Red', true, true)
				end
				return true
			end
		}))
	end
	-- trigger_effect = function()
	-- 	if G.GAME.last_blind and G.GAME.last_blind.boss then
	-- 		G.E_MANAGER:add_event(Event({
	-- 			func = (function()
	-- 				add_tag(Tag('tag_double'))
	-- 				return true
	-- 			end)
	-- 		}))
	-- 	end
	-- end
}

----------------------------------------------
------------MOD CODE END----------------------
	