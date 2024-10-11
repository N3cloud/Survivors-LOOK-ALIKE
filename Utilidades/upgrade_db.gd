extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const ALL_PATH = "res://Textures/Items/32x32/"
const UPGRADES = {
	"flecha1": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "Una flecha es lanzada a un enemigo aleatorio",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"flecha2": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "Una flecha adicional es lanzada a un enemigo aleatorio",
		"level": "Nivel: 2",
		"prerequisite": ["flecha1"],
		"type": "weapon"
	},
	"flecha3": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "La flecha ahora atraviesa otro enemigo y hace +3 de daño",
		"level": "Nivel: 3",
		"prerequisite": ["flecha2"],
		"type": "weapon"
	},
	"flecha4": {
		"icon": WEAPON_PATH + "Arrow01(32x32).png",
		"displayname": "Flecha",
		"details": "2 flechas adicionales",
		"level": "Nivel: 4",
		"prerequisite": ["flecha3"],
		"type": "weapon"
	},
	"dark1": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Calavera Oscura",
		"details": "Una calavera mágica es lanzada hacia los enemigos",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"dark2": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Tornado",
		"details": "Una calavera adicional es lanzada",
		"level": "Nivel: 2",
		"prerequisite": ["dark1"],
		"type": "weapon"
	},
	"dark3": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Tornado",
		"details": "El tiempo de reutilización de la calavera se reduce en 0.5 segundos",
		"level": "Nivel: 3",
		"prerequisite": ["dark2"],
		"type": "weapon"
	},
	"dark4": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Tornado",
		"details": "Se lanza una calavera adicional y se aumenta el retroceso un 25%",
		"level": "Nivel: 4",
		"prerequisite": ["dark3"],
		"type": "weapon"
	},
	"fuego1": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Circulo solar",
		"details": "Un circulo de fuego orbita alrededor del jugador",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"rayo1": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Alas de trueno",
		"details": "Un ave ataca a un enemigo aleatorio",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"regeneracion1": {
		"icon": ALL_PATH + "spellbook_03e.png",
		"displayname": "Regeneración",
		"details": "Regenera 0.1 de vida por segundo",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "item"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño en 1 punto",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño en 1 punto",
		"level": "Nivel: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño en 1 punto",
		"level": "Nivel: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduce el daño en 1 punto",
		"level": "Nivel: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Incrementa la velocidad en un 50%",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Incrementa la velocidad en un 50%",
		"level": "Nivel: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Incrementa la velocidad en un 50%",
		"level": "Nivel: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidad",
		"details": "Incrementa la velocidad en un 50%",
		"level": "Nivel: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "En pruebas",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "En pruebas",
		"level": "Nivel: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "En pruebas",
		"level": "Nivel: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tomo",
		"details": "En pruebas",
		"level": "Nivel: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Disminuye el cooldown de las habilidades en 5%",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Disminuye el cooldown de las habilidades en 5%",
		"level": "Nivel: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Disminuye el cooldown de las habilidades en 5%",
		"level": "Nivel: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergamino",
		"details": "Disminuye el cooldown de las habilidades en 5%",
		"level": "Nivel: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anillo",
		"details": "Los ataques tienen 1 proyectil adicional",
		"level": "Nivel: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anillo",
		"details": "Los ataques tienen 1 proyectil adicional",
		"level": "Nivel: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
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
