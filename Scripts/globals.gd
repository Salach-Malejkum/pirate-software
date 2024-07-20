class_name Globals

# no support for string enum, add path to texture below to access
enum card_types {WATER, FIRE, STEAM}

const card_texture_paths = [
	"res://ArtAssets/Cards/card_water.png",
	"res://ArtAssets/Cards/card_fire.png",
	"res://ArtAssets/Cards/card_steam.png"
]

const card_merge_results = {
	"WATER+FIRE": card_types.STEAM
}

const max_cards_at_hand : int = 5
