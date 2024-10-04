extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADES = {
	"flecha1": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "Una flecha es lanzada a un enemigo aleatorio",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Ataque"
	},
	"flecha2": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "Una flecha adicional es lanzada a un enemigo aleatorio",
		"level": "Nivel: 2",
		"prerequisite": ["flecha1"],
		"type": "Ataque"
	},
	"flecha3": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "La flecha ahora atraviesa otro enemigo y hace +3 de daño",
		"level": "Nivel: 3",
		"prerequisite": ["flecha2"],
		"type": "Ataque"
	},
	"flecha4": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "An additional 2 Ice Spears are thrown",
		"level": "Nivel: 4",
		"prerequisite": ["flecha3"],
		"type": "Ataque"
	},
	"dark1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "A tornado is created and random heads somewhere in the players direction",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Ataque"
	},
	"dark2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional Tornado is created",
		"level": "Nivel: 2",
		"prerequisite": ["dark1"],
		"type": "Ataque"
	},
	"dark3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "The Tornado cooldown is reduced by 0.5 seconds",
		"level": "Nivel: 3",
		"prerequisite": ["dark2"],
		"type": "Ataque"
	},
	"dark4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created and the knockback is increased by 25%",
		"level": "Nivel: 4",
		"prerequisite": ["dark3"],
		"type": "Ataque"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduces Damage By 1 point",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Mejora"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Nivel: 2",
		"prerequisite": ["armor1"],
		"type": "Mejora"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Nivel: 3",
		"prerequisite": ["armor2"],
		"type": "Mejora"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Nivel: 4",
		"prerequisite": ["armor3"],
		"type": "Mejora"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Mejora"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Nivel: 2",
		"prerequisite": ["speed1"],
		"type": "Mejora"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Nivel: 3",
		"prerequisite": ["speed2"],
		"type": "Mejora"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Nivel: 4",
		"prerequisite": ["speed3"],
		"type": "Mejora"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Mejora"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Nivel: 2",
		"prerequisite": ["tome1"],
		"type": "Mejora"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Nivel: 3",
		"prerequisite": ["tome2"],
		"type": "Mejora"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Nivel: 4",
		"prerequisite": ["tome3"],
		"type": "Mejora"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Mejora"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Nivel: 2",
		"prerequisite": ["scroll1"],
		"type": "Mejora"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Nivel: 3",
		"prerequisite": ["scroll2"],
		"type": "Mejora"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Nivel: 4",
		"prerequisite": ["scroll3"],
		"type": "Mejora"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anillo",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "Mejora"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anillo",
		"details": "Your spells now spawn an additional attack",
		"level": "Nivel: 2",
		"prerequisite": ["ring1"],
		"type": "Mejora"
	},
	"comida": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Comida",
		"details": "Cura 20 de vida",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
