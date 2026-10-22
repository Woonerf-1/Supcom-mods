-- Nomads: Zugriff auf die aktuelle Auswahl der Befehlsleiste, siehe doc.claude\mods\Nomads.md (Abschnitt Hooks).
-- currentSelection ist in LOUDs orders.lua lokal (Z. 229); der Hook sieht es, weil er an die Datei angehaengt wird.
-- Genutzt vom Capacitor-Knopf (hook\lua\abilitydefinition.lua). Der uebrige alte Hook (FAF-CreateAltOrders,
-- AddAbilityButtons) lief in LOUD nie und ist entfallen.
function GetCurrentSelection()
    return currentSelection
end
