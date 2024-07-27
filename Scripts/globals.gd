class_name Globals

# no support for string enum, add path to texture below to access
enum card_types {WATER, FIRE, STEAM, ELECTRICITY, CANDLE, CANDLE_LIT, ESSENCE, CULT_MARK, BEAST_HEAD}

const card_texture_paths = [
	"res://ArtAssets/Cards/card_water_4_px.png",
	"res://ArtAssets/Cards/card_fire_4_px.png",
	"res://ArtAssets/Cards/card_steam_4_px.png",
	"res://ArtAssets/Cards/card_electricity_4_px.png",
	"res://ArtAssets/Cards/card_candle_4_px.png",
	"res://ArtAssets/Cards/card_candle_light_4_px.png",
	"res://ArtAssets/Cards/card_essence_4_px.png",
	"res://ArtAssets/Cards/card_cult_mark_4_px.png",
	"res://ArtAssets/Cards/card_beast_4_px.png"
]

const card_merge_results = {
	"WATER+FIRE": card_types.STEAM,
	"CANDLE+FIRE": card_types.CANDLE_LIT,
	"STEAM+ELECTRICITY": card_types.ESSENCE,
	"ESSENCE+WATER": card_types.CULT_MARK,
	"CULT_MARK+CANDLE_LIT": card_types.BEAST_HEAD
}

const max_cards_at_hand : int = 5
const interactable_light_energy = 1.0
const light_delta_modifier = 10.0
const random_card_pull_time = 15.0

const tutorial_text_timer = 7.0
