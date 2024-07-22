class_name Globals

# no support for string enum, add path to texture below to access
enum card_types {WATER, FIRE, STEAM, ELECTRICITY, CANDLE, CANDLE_LIT}

const card_texture_paths = [
	"res://ArtAssets/Cards/card_water.png",
	"res://ArtAssets/Cards/card_fire.png",
	"res://ArtAssets/Cards/card_steam.png",
	"res://ArtAssets/Cards/card_electricity.png",
	"res://ArtAssets/Cards/card_candle.png",
	"res://ArtAssets/Cards/card_candle_light.png"
]

const card_merge_results = {
	"WATER+FIRE": card_types.STEAM,
	"CANDLE+FIRE": card_types.CANDLE_LIT
}

const max_cards_at_hand : int = 5
const interactable_light_energy = 0.4
const light_delta_modifier = 10.0
