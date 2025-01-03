SMODS.Atlas {
	key = "ModdedVanilla",
	path = "ModdedVanilla.png",
	px = 71,
	py = 95
}


SMODS.Joker {
	key = 'redJoker',
	loc_txt = {
		name = 'Red Joker',
		text = {
			"{C:mult}+2{} Mult for each",
			"remaining card in {C:attention}hand"
		}
	},
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 5, y = 1 },
	cost = 2,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = 2*#G.hand.cards,
				message = localize { type = 'variable', key = 'a_mult', vars = { 2*#G.hand.cards } }
			}
		end
	end
}


SMODS.Joker {
	key = 'dumpsterFire',
	loc_txt = {
		name = 'Dumpster Fire',
		text = {
			"Every discarded card",
			"is {C:attention}Destroyed!"
		}
	},
	rarity = 3,
	atlas = 'ModdedVanilla',
	pos = {x=5,y=1},
	cost=6,
	calculate = function(self,card,context)
		if context.discard and not context.blueprint then
			return {
				remove = true,
				card = context.other_card
			}
		end
	end
}


-- example jokers below

SMODS.Joker {
	key = 'joker+',
	loc_txt = {
		name = 'Joker Plus',
		text = {
			"{C:mult}+#1# {} Mult"
		}
	},
	config = { extra = { mult = 6} },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult} }
	end,
	rarity = 2,
	atlas = 'ModdedVanilla',
	pos = { x = 0, y = 0 },
	cost = 3,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'sprinter',
	loc_txt = {
		name = 'Sprinter',
		text = {
			"Gains {C:chips}+#2#{} Chips",
			"if played hand",
			"contains a {C:attention}Straight{}",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		}
	},
	config = { extra = { chips = 0, chip_gain = 15 } },
	rarity = 2,
	atlas = 'ModdedVanilla',
	pos = { x = 1, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
		if context.before and next(context.poker_hands['Straight']) then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = 'Upgraded!',
				colour = G.C.CHIPS,
				-- The return value, "card", is set to the variable "card", which is the joker.
				-- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
				-- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'leaper',
	loc_txt = {
		name = 'Leaper',
		text = {
			"Gains {C:mult}x#2#{} Mult",
			"if played hand",
			"contains a {C:attention}Straight Flush{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	config = { extra = { mult = 1, mult_gain = 2 } },
	rarity = 3,
	atlas = 'ModdedVanilla',
	pos = { x = 1, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
		if context.before and next(context.poker_hands['Straight Flush']) and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult * card.ability.extra.mult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'golden2',
	loc_txt = {
		name = 'Golden Joker 2',
		text = {
			"Earn {C:money}$#1#{} at",
			"end of round.",
			"Increases by {C:money}$#2#{}"
		}
	},
	config = { extra = { money = 1, money_gain = 1 } },
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 2, y = 0 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.money_gain } }
	end,
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain
		return bonus
	end
}


SMODS.Joker {
	key = 'cheekyAndy',
	loc_txt = {
		name = 'Cheeky Andy',
		text = {
			"{C:red}#1#{} discards",
			"each round,",
			"{C:red}+#2#{} hand size"
		}
	},
	config = { extra = { discard_size = -1, hand_size = 1 } },
	rarity = 2,
	atlas = 'ModdedVanilla',
	pos = { x = 3, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discard_size, card.ability.extra.hand_size } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_size
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_size
		G.hand:change_size(-card.ability.extra.hand_size)
	end
}


SMODS.Joker {
	key = 'primeTime',
	loc_txt = {
		name = 'Prime Time',
		text = {
			"Retrigger all",
			"played {C:attention}prime{} cards"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2,
	atlas = 'ModdedVanilla',
	pos = { x = 4, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			local prime = {[14] = true,[2] = true,[3] = true,[5] = true,[7] = true}
			if prime[context.other_card:get_id()] then
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
	end
}


SMODS.Joker {
	key = 'perkeo2',
	loc_txt = {
		name = 'Perkeo 2',
		text = {
			"Creates a {C:dark_edition}Negative{} copy of",
			"{C:attention}1{} random {C:attention}joker{}",
			"card in your possession",
			"at the end of the {C:attention}shop",
		}
	},
	-- Extra is empty, because it only happens once. If you wanted to copy multiple cards, you'd need to restructure the code and add a for loop or something.
	config = { extra = {} },
	rarity = 4,
	atlas = 'ModdedVanilla',
	pos = { x = 0, y = 1 },
	soul_pos = { x = 4, y = 1 },
	cost = 20,
	calculate = function(self, card, context)
		if context.ending_shop then
			G.E_MANAGER:add_event(Event({
				func = function()
					-- pseudorandom_element is a vanilla function that chooses a single random value from a table of values, which in this case, is your consumables.
					-- pseudoseed('perkeo2') could be replaced with any text string at all - It's simply a way to make sure that it's affected by the game seed, because if you use math.random(), a base Lua function, then it'll generate things truly randomly, and can't be reproduced with the same Balatro seed. LocalThunk likes to have the joker names in the pseudoseed string, so you'll often find people do the same.
					local card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('perkeo2')), nil)
					
					-- Vanilla function, it's (edition, immediate, silent), so this is ({edition = 'e_negative'}, immediate = true, silent = nil)
					card:set_edition('e_negative', true)
					card:add_to_deck()
					-- card:emplace puts a card in a cardarea, this one is G.consumeables, but G.jokers works, and custom card areas could also work.
					-- I think playing cards use "create_playing_card()" and are separate.
					G.jokers:emplace(card)
					return true
				end
			}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
			{ message = localize('k_duplicated_ex') })
		end
	end
}


SMODS.Joker {
	key = 'evening',
	loc_txt = {
		name = 'Evening',
		text = {
			"Each played {C:attention}Even card{}",
			"gives {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when scored"
		}
	},
	config = { extra = { chips = 4, mult = 2 } },
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 1, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id()%2 == 0 then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}

-- Bananas!
SMODS.Joker {
	key = 'gros_michel2',
	loc_txt = {
		name = 'Gros Michel 2',
		text = {
			"{C:mult}+#1#{} Mult",
			"{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
	-- This searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, no longer shows up in the shop.
	no_pool_flag = 'gros_michel_extinct2',
	config = { extra = { mult = 15, odds = 6 } },
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 2, y = 1 },
	cost = 5,
	-- Gros Michel is incompatible with the eternal sticker, so this makes sure it can't be eternal.
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
		
		-- Checks to see if it's end of round, and if context.game_over is false.
		-- Also, not context.repetition ensures it doesn't get called during repetitions.
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			-- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
			if pseudorandom('gros_michel2') < G.GAME.probabilities.normal / card.ability.extra.odds then
				-- This part plays the animation.
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				-- Sets the pool flag to true, meaning Gros Michel 2 doesn't spawn, and Cavendish 2 does.
				G.GAME.pool_flags.gros_michel_extinct2 = true
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
		end
	end
}
SMODS.Joker {
	key = 'cavendish2',
	loc_txt = {
		name = 'Cavendish 2',
		text = {
			"{X:mult,C:white} X#1# {} Mult",
			"{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
	-- This also searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, enables the ability to show up in shop.
	yes_pool_flag = 'gros_michel_extinct2',
	config = { extra = { Xmult = 3, odds = 1000 } },
	rarity = 1,
	atlas = 'ModdedVanilla',
	pos = { x = 3, y = 1 },
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
		if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
			if pseudorandom('cavendish2') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
		end
	end
}

-- Castle
SMODS.Joker {
	key = 'castle2',
	loc_txt = {
		name = 'Castle 2',
		text = {
			"This Joker gains {C:chips}+#1#{} Chips",
			"per discarded {V:1}#2#{} card,",
			"suit changes every round",
			"{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips)",
		}
	},
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	rarity = 2,
	cost = 6,
	config = { extra = { chips = 0, chip_mod = 3 }},
	atlas = 'ModdedVanilla',
	pos = { x = 5, y = 0 },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.chip_mod, 
			localize(G.GAME.current_round.castle2_card.suit, 'suits_singular'), -- gets the localized name of the suit 
			card.ability.extra.chips,
			colours = {G.C.SUITS[G.GAME.current_round.castle2_card.suit]} -- sets the colour of the text affected by `{V:1}`
		}}
	end,
	calculate = function(self, card, context)
		if 
		context.discard and 
		not context.other_card.debuff and 
		context.other_card:is_suit(G.GAME.current_round.castle2_card.suit) and 
		not context.blueprint
		then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
		end
		if context.joker_main and card.ability.extra.chips > 0 then
			return {
				message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
				chip_mod = card.ability.extra.chips, 
				colour = G.C.CHIPS
			}
		end
	end
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.castle2_card = { suit = 'Spades' } 
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
	-- The suit changes every round, so we use reset_game_globals to choose a suit.
	G.GAME.current_round.castle2_card = { suit = 'Spades' }
	local valid_castle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then -- Abstracted enhancement check for jokers being able to give cards additional enhancements
			valid_castle_cards[#valid_castle_cards+1] = v
		end
	end
	if valid_castle_cards[1] then 
		local castle_card = pseudorandom_element(valid_castle_cards, pseudoseed('2cas'..G.GAME.round_resets.ante))
		G.GAME.current_round.castle2_card.suit = castle_card.base.suit
	end
end