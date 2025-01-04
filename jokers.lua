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
		},
		unlock = {
			"Have {C:attention}10{} or less cards",
			"remaining in {C:attention}hand"
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
	end,
	unlocked = false,
	discovered = false,
	-- on play have 10 cards remaining in hand
	check_for_unlock = function(self, args)
		if args.type == 'hand' and #G.hand.cards > 9 then
			unlock_card(self)
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
		},
		unlock = {
			"Reduce your deck",
			"to {C:attention}26{} cards"
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
	end,
	unlocked = false,
	discovered = false,
	-- on remove cards from deck if deck < 27
	check_for_unlock = function(self, args)
		if G.deck and G.deck.config.card_limit < 27 then
			unlock_card(self)
		end
	end
}


SMODS.Joker {
	key = 'oneMansTrash',
	loc_txt = {
		name = 'One Man\'s Trash',
		text = {
			"At the end of each round",
			"{C:money}$1{} per remaining {C:red}discard"
		}
	},
	rarity = 2,
	atlas = 'ModdedVanilla',
	pos = {x=2,y=0},
	cost=3,
	calc_dollar_bonus = function(self, card)
		return G.GAME.current_round.discards_left
	end,
	unlocked = false,
	discovered = false,
	check_for_unlock = function(self, args)
		if args.type == "ante_up" and args.ante == 9 and G.GAME.unused_discards == 0 then
			unlock_card(self)
		end
	end
	-- want to change from cacl_dollar_bonus to alter money_per_discard
	-- add_to_deck = function(self, card, from_debuff)
	-- remove_from_deck = function(self, card, from_debuff)
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
			"at the end of the {C:attention} shop",
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