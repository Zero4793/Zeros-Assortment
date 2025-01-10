SMODS.Atlas {
	key = "ModdedVanilla",
	path = "ModdedVanilla.png",
	px = 71,
	py = 95
}

-- Red Joker
SMODS.Joker {
	key = 'redJoker',
	atlas = 'ModdedVanilla',
	pos = { x = 5, y = 1 },
	loc_txt = {
		name = 'Red Joker',
		text = {
			"{C:mult}+2{} Mult for each",
			"remaining card in {C:attention}hand"
		},
		unlock = {
			"Have {C:attention}10{} or more cards",
			"remaining in {C:attention}hand"
		}
	},
	rarity = 1,
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

-- Dumpster Fire
SMODS.Joker {
	key = 'dumpsterFire',
	atlas = 'ModdedVanilla',
	pos = {x=5,y=1},
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
	cost=8,
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

-- One Man's Trash
SMODS.Joker {
	key = 'oneMansTrash',
	atlas = 'ModdedVanilla',
	pos = {x=2,y=0},
	loc_txt = {
		name = 'One Man\'s Trash',
		text = {
			"At the end of each round",
			"gain {C:money}$1{} per remaining {C:red}discard"
		},
		unlock = {
			"Finish a run with {C:attention}no unused {C:red}discards"
		}
	},
	rarity = 1,
	cost = 4,
	calc_dollar_bonus = function(self, card)
		return G.GAME.current_round.discards_left
	end,
	unlocked = false,
	discovered = false,
	-- finish a run with no unused discards
	check_for_unlock = function(self, args)
		if args.type == "ante_up" and args.ante == 9 and G.GAME.unused_discards == 0 then
			unlock_card(self)
		end
	end
	-- want to change from cacl_dollar_bonus to alter money_per_discard
	-- add_to_deck = function(self, card, from_debuff)
	-- remove_from_deck = function(self, card, from_debuff)
}

-- Noble
SMODS.Joker {
	key = 'noble',
	atlas = 'ModdedVanilla',
	pos = { x = 4, y = 0 },
	loc_txt = {
		name = 'Noble Joker',
		text = {
			"{C:mult}+1{} Mult per",
			"{C:attention}face{} card in your full deck"
		},
		unlock = {
			"Have {C:attention}24{} or more face cards",
			"in your full deck"
		}
	},
	rarity = 2,
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
			local face_count = 0
			for _, card in pairs(G.playing_cards) do
				if card:is_face() and not card.debuff then
					face_count = face_count + 1
				end
			end
			return {
				mult_mod = face_count,
				message = localize { type = 'variable', key = 'a_mult', vars = { face_count } }
			}
		end
	end,
	unlocked = false,
	discovered = false,
	-- reach 24 face cards in deck
	check_for_unlock = function(self, args)
		if G.deck and G.deck.config.card_limit > 23 then
			local face_count = 0
			for _, card in pairs(G.playing_cards) do
				if card:is_face() and not card.debuff then
					face_count = face_count + 1
				end
			end
			if face_count > 23 then
				unlock_card(self)
			end
		end
	end
}

-- Leaper
SMODS.Joker {
	key = 'leaper',
	atlas = 'ModdedVanilla',
	pos = { x = 1, y = 0 },
	loc_txt = {
		name = 'Leaper',
		text = {
			"{C:mult}Mult gain{} doubles",
			"if played hand",
			"contains a {C:attention}Straight Flush{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	rarity = 3,
	cost = 8,
	config = { extra = { mult = 1, mult_gain = 2 } },
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
	-- add an unlock
}

-- Prime Time
SMODS.Joker {
	key = 'primeTime',
	atlas = 'ModdedVanilla',
	pos = { x = 4, y = 0 },
	loc_txt = {
		name = 'Prime Time',
		text = {
			"{C:attention}Prime{} cards score",
			"their rank as {C:mult}Mult"
		},
		unlock = {
			"Play a hand of {C:blue}5{} {C:attention}7's{}"
		}
	},
	rarity = 1,
	cost = 4,
	calculate = function(self, card, context)
		if context.cardarea == G.play then
			local prime = {[14] = true,[2] = true,[3] = true,[5] = true,[7] = true}
			if prime[context.other_card:get_id()] then
				local num = context.other_card:get_id()
				if num == 14 then num = 1 end
				return {
					mult = num,
					card = context.other_card
				}
			end
		end
	end,
	unlocked = false,
	discovered = false,
	-- play a hand of 5 7's
	check_for_unlock = function(self, args)
		if args.type == 'hand' and #args.scoring_hand == 5 then -- or args.handname == 'Five of a Kind' or args.handname == 'Flush Five' then
			for _, card in pairs(args.scoring_hand) do
				if card:get_id() ~= 7 then
					return false
				end
			end
			unlock_card(self)
		end
	end
}

-- Perke no
SMODS.Joker {
	key = 'perkeno',
	atlas = 'ModdedVanilla',
	pos = { x = 0, y = 1 },
	soul_pos = { x = 4, y = 1 },
	loc_txt = {
		name = 'Perke No',
		text = {
			"Creates a {C:dark_edition}Negative{} copy of",
			"a random {C:attention}joker{} when",
			"you enter {C:attention}Boss Blind"
		}
	},
	rarity = 4,
	cost = 20,
	calculate = function(self, card, context)
		if context.blind and context.blind.boss then
			G.E_MANAGER:add_event(Event({
				func = function()
					local card = copy_card(pseudorandom_element(G.jokers.cards, pseudoseed('perkeno')), nil)
					card:set_edition('e_negative', true)
					card:add_to_deck()
					G.jokers:emplace(card)
					return true
				end
			}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
			{ message = localize('k_duplicated_ex') })
		end
	end
	-- no unlock since legendary
}

-- Green Joker
SMODS.Joker:take_ownership('j_green_joker', {
	config = { extra = { hand_add = 2, discard_sub = 2 } }
})

-- Wild Child
SMODS.Joker {
	key = 'wildChild',
	atlas = 'ModdedVanilla',
	pos = { x = 5, y = 0 },
	loc_txt = {
		name = 'Wild Child',
		text = {
			"{X:mult,C:white}X1{} + {X:mult,C:white}X1{} per {C:blue}wild card",
			"in scored hand"
		}
		-- unlock = {
		-- 	"Play a hand of {C:blue}5{} {C:attention}wild cards{}"
		-- }
	},
	rarity = 2,
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
			local wild_count = 1
			for _, card in pairs(context.scoring_hand) do
				if card.label == 'Wild Card' then
					wild_count = wild_count + 1
				end
			end
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { wild_count } },
				Xmult_mod = wild_count
			}
		end
	end
} -- add unlock