-- ==========================================================================
--  performance.lua - Gaming, Latenz und MangoHud
--  Herausgeloest aus der alten KI-hyprland.lua (Stand 19.11.2026).
--
--  Einbinden: in deiner hyprland.lua ganz oben diese Zeile:
--      require("performance")
--  Hyprland sucht die Datei im selben Ordner wie hyprland.lua.
--  Steht eine Einstellung hier UND in deiner hyprland.lua, gewinnt die,
--  die spaeter kommt (also deine, wenn require ganz oben steht).
-- ==========================================================================


-----------------
---- MANGOHUD ----
-----------------

-- MangoHud laeuft in jedem Vulkan-Spiel mit (globaler Layer).
-- Was es anzeigt und das FPS-Limit (162): ~/.config/MangoHud/MangoHud.conf
-- Eigene Einstellungen pro Spiel: ~/.config/MangoHud/<spiel>.conf (z. B. cs2.conf)
-- Gilt erst nach dem naechsten Einloggen.
hl.env("MANGOHUD", "1")

-- Optional (niedrige Latenz bei OpenGL): erst einschalten, wenn alles andere laeuft.
-- hl.env("__GL_MaxFramesAllowed", "1")


--------------------------------------
---- LATENZ, G-SYNC/VRR, TEARING ----
--------------------------------------

hl.config({
    general = {
        allow_tearing = true,       -- Spiele duerfen tearen, wenn sie es wollen (weniger Input-Lag)
    },
    render = {
        direct_scanout = true,      -- Vollbild-Spiele gehen direkt an den Monitor, an Hyprland vorbei
        cm_auto_hdr    = 0,         -- kein automatisches HDR
    },
    misc = {
        vrr = 2,                    -- G-Sync/VRR: 0 = aus, 1 = immer, 2 = nur im Vollbild
    },
    cursor = {
        no_break_fs_vrr     = 1,    -- Mausbewegung bricht VRR im Vollbild nicht ab
        no_hardware_cursors = 0,    -- Hardware-Cursor an (schneller)
        min_refresh_rate    = 48,   -- untere Grenze fuer VRR
    },
    input = {
        accel_profile = "flat",     -- keine Mausbeschleunigung (Maus bewegt sich 1:1)
        sensitivity   = 0,
    },
})


-----------------------------------
---- REGELN FUER VIDEOS/SPIELE ----
-----------------------------------

-- Videos: kein Tearing, kein VRR (sonst flackert es)
hl.window_rule({
    name      = "no-tearing-video",
    match     = { class = "crunchyroll|firefox" },
    no_vrr    = true,
    immediate = false,
})

-- DOOM (Steam-App 379720) im echten Vollbild
hl.window_rule({
    name             = "doom-fullscreen",
    match            = { class = "steam_app_379720" },
    fullscreen_state = "2 2",
})


------------------
---- WERKZEUG ----
------------------

-- Super + Pos1: zeigt, ob Direct Scanout gerade aktiv ist
hl.bind("SUPER + Home", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/check-direct-scanout"))
