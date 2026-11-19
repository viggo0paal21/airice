-- ==========================================================================
--  HYPRLAND (Lua-Config) - Grundgeruest fuer den Terminal-Rice
--  Doku:  https://wiki.hypr.land/Configuring/Start/
--  Rice:  ~/.config/rice/README.md (was wo liegt, Farben, Schrift, Animationen)
--  Speichern reicht, Hyprland laedt die Datei selbst neu. Autostart und
--  Umgebungsvariablen gelten erst nach dem naechsten Einloggen.
-- ==========================================================================


------------------
---- FARBEN ----
------------------

-- Schwarz-Weiss, dieselben Werte wie in Waybar, rofi, swaync, kitty und hyprlock.
-- Hier nur fuer die Fensterrahmen. Ohne "#", als Hex.
local colors = {
    fg  = "ffffff", -- aktiver Fensterrahmen
    dim = "808080", -- inaktiver Fensterrahmen
}


------------------
---- TEMPO ----
------------------

-- Steuert ALLE Animationen auf einmal (die einzelnen stehen unten im Abschnitt ANIMATIONEN).
local anim = {
    an    = true, -- false = alle Animationen aus
    tempo = 0.75,    -- 1 = normal (Fenster ca. 200 ms), 2 = doppelt so schnell, 0.5 = halb so schnell (nie 0)
}


------------------
---- MONITORE ----
------------------

-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Werte ansehen: hyprctl monitors
hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@170",
    position = "auto",
    scale    = "auto",
})


-------------------
---- PROGRAMME ----
-------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "pkill rofi || rofi -show drun"
local powermenu   = os.getenv("HOME") .. "/.local/bin/rice-power"
local lock        = "pidof hyprlock || hyprlock"
local reload      = os.getenv("HOME") .. "/.local/bin/rice-reload"


-------------------
---- AUTOSTART ----
-------------------

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Laeuft nur beim Einloggen, nicht beim Neuladen der Config.
-- rice-reload startet Waybar, swaync und das Wallpaper (dasselbe wie Super + Shift + R).
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd GDK_WAYLAND_DISABLE")
    hl.exec_cmd(reload)
    hl.exec_cmd("sleep 3 && arch-update --tray")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)


-------------------------------
---- UMGEBUNGSVARIABLEN ----
-------------------------------

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- Gelten erst nach einem Neustart von Hyprland.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")
-- Qt-Apps (Dolphin, KDE-Programme ...) im Rice-Look: Kvantum-Theme "MonochromeSolid" (schwarz-weiss, deckend)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
hl.env("ADW_DISABLE_PORTAL", "1")
hl.env("GTK_USE_PORTAL", "1")
-- MangoHud als globaler Vulkan-Layer. FPS-Limit in ~/.config/MangoHud/MangoHud.conf
hl.env("MANGOHUD", "1")

-- Optional (niedrige Latenz bei OpenGL): erst einschalten, wenn alles andere laeuft.
-- hl.env("__GL_MaxFramesAllowed", "1")


-----------------------
---- BERECHTIGUNGEN ----
-----------------------

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


--------------
---- LOOK ----
--------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/
-- Terminal-Look: eckige Fenster, duenner heller Rahmen ums aktive Fenster, kein Schatten, kein Blur.
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = { top = 10, right = 10, bottom = 10, left = 10 },
        border_size = 2,

        col = {
            active_border   = "rgba(" .. colors.fg .. "ff)",
            inactive_border = "rgba(" .. colors.dim .. "ff)",
        },

        resize_on_border = true,
        allow_tearing    = true,
        layout           = "dwindle",

        -- Schwebende Fenster rasten beim Ziehen an anderen Fenstern und am Bildschirmrand ein
        snap = {
            enabled      = true,
            window_gap   = 15,
            monitor_gap  = 15,
            respect_gaps = true,
        },
    },

    decoration = {
        rounding = 0,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        -- Kein Glas, keine Transparenz.
        blur = {
            enabled = false,
            size    = 10,
            passes  = 3,
        },
    },

    -- Animationen an/aus: oben bei TEMPO (anim.an). Kurven und Dauer stehen weiter unten (hl.curve / hl.animation).
    animations = {
        enabled = anim.an,
    },
})


--------------------
---- ANIMATIONEN ----
--------------------

-- https://wiki.hypr.land/configuring/core/animations/
-- Kurz und ohne Nachfedern, passend zum schlichten Look: Fenster blenden ein und wachsen dabei nur
-- minimal (95 % -> 100 %), Workspaces schieben sich ein kleines Stueck und blenden dabei ueber.
-- speed = Dauer in Zehntelsekunden bei tempo 1 (2 = 200 ms, kleiner = schneller).
-- "/ anim.tempo" teilt jede Dauer durch das Tempo oben, so aendert eine Zahl alles gleichzeitig.
-- Die Zahlen hier nur aendern, wenn EINE Animation im Verhaeltnis zu den anderen schneller/langsamer soll.
-- Alles aus: oben bei TEMPO "an = false".

-- Kurve "snap": schnell los, weich ankommen, kein Ueberschwingen (der Grossteil der Bewegung ist nach
-- einem Viertel der Zeit schon passiert, darum wirkt es noch schneller als die Zahl)
hl.curve("snap",   { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0},    {1, 1}   } })

hl.animation({ leaf = "global",           enabled = true, speed = 2   / anim.tempo, bezier = "snap" })
hl.animation({ leaf = "border",           enabled = true, speed = 2   / anim.tempo, bezier = "snap" })
hl.animation({ leaf = "windows",          enabled = true, speed = 2   / anim.tempo, bezier = "snap" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 2   / anim.tempo, bezier = "snap",   style = "popin 95%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 1.2 / anim.tempo, bezier = "linear", style = "popin 95%" })
hl.animation({ leaf = "fade",             enabled = true, speed = 1.5 / anim.tempo, bezier = "snap" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1   / anim.tempo, bezier = "linear" })
hl.animation({ leaf = "layers",           enabled = true, speed = 1.5 / anim.tempo, bezier = "snap",   style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1   / anim.tempo, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1   / anim.tempo, bezier = "linear" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 2   / anim.tempo, bezier = "snap",   style = "slidefade 10%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2   / anim.tempo, bezier = "snap",   style = "slidefadevert 10%" })
hl.animation({ leaf = "zoomFactor",       enabled = true, speed = 3   / anim.tempo, bezier = "snap" })


---------------------
---- LAYER-REGELN ----
---------------------

-- Benachrichtigungen gleiten von rechts rein
hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    animation = "slide right",
})

-- rofi: Blur (wirkt nur, wenn oben decoration.blur an ist)
hl.layer_rule({
    match = { namespace = "rofi" },
    name = "rofi-blur",
    blur = true,
    ignore_alpha = 0,
})


----------------------
---- FENSTERREGELN ----
----------------------

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Kein Tearing / kein VRR bei Videos
hl.window_rule({
    name  = "no-tearing-video",
    match = { class = "crunchyroll|firefox" },
    no_vrr = true,
    immediate = false,
})

hl.window_rule({
    name  = "doom-fullscreen",
    match = { class = "steam_app_379720" },
    fullscreen_state = "2 2",
})

-- Maximieren-Anfragen von Apps ignorieren
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Behebt Probleme beim Ziehen unter XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Smart borders: genau 1 gekacheltes Fenster -> kein Rahmen (schwebende zaehlen nicht)
hl.window_rule({
    name = "smart-border-single-tiled",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
})

-- Schwebende Fenster behalten IMMER ihren Rahmen
hl.window_rule({
    name = "smart-border-floating-override",
    match = { float = true },
    border_size = 2,
})


-----------------
---- LAYOUTS ----
-----------------

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
---- SONSTIGES ----
----------------

hl.config({
    render = {
        direct_scanout = true,
        cm_auto_hdr    = 0,
    },
    misc = {
        force_default_wallpaper = 0,     -- kein Hyprland-Maskottchen als Wallpaper
        disable_hyprland_logo   = false,
        vrr                     = 2,     -- G-Sync/VRR nur im Vollbild (1 = immer)
    },
    cursor = {
        no_break_fs_vrr     = 1,
        no_hardware_cursors = 0,
        min_refresh_rate    = 48,
    },
})


---------------
---- EINGABE ----
---------------

hl.config({
    input = {
        kb_layout  = "de",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        -- Keine Mausbeschleunigung
        accel_profile = "flat",
        sensitivity   = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


------------------------
---- TASTENKUERZEL ----
------------------------

-- https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu))                         -- App-Launcher (rofi)
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd(lock))                         -- Bildschirm sperren
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(powermenu))                    -- Power-Menue
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("swaync-client -t -sw"))       -- Benachrichtigungen
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("waypaper"))                   -- Wallpaper waehlen
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(reload))                   -- Leiste, Benachrichtigungen, Wallpaper neu starten
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",      hl.dsp.layout("togglesplit"))                  -- nur dwindle
hl.bind("SUPER + Home",         hl.dsp.exec_cmd(os.getenv("HOME") .. "/.local/bin/check-direct-scanout"))

-- Fokus mit Super + Pfeiltasten
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces: Super + 1-0, Fenster verschieben: Super + Shift + 1-0
for i = 1, 10 do
    local key = i % 10 -- 10 = Taste 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- Screenshot von einem Bereich in die Zwischenablage
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- Durch Workspaces scrollen
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Fenster mit Super + linker/rechter Maustaste verschieben/vergroessern
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lautstaerke und Helligkeit
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Medientasten (playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


-- ── Super + V: Fenster schwebend in 16:9 (60 % der Bildschirmbreite, mittig) ──
local FLOAT_SHARE     = 0.6   -- Breite = 60 % der Monitorbreite
local ONLY_FIRST_TIME = true  -- true = danach merkt sich Hyprland deine eigene Groesse

local already_floated = {}

local function toggle_float_16_9()
    local w = hl.get_active_window()
    if not w then return end

    -- schwebt schon -> zurueck ins Kacheln
    if w.floating then
        hl.dispatch(hl.dsp.window.float({ action = "unset" }))
        return
    end

    hl.dispatch(hl.dsp.window.float({ action = "set" }))

    if ONLY_FIRST_TIME and already_floated[w.address] then return end
    already_floated[w.address] = true

    local m      = w.monitor
    local width  = math.floor(m.width / m.scale * FLOAT_SHARE)
    local height = math.floor(width * 9 / 16)

    hl.dispatch(hl.dsp.window.resize({ x = width, y = height, relative = false }))
    hl.dispatch(hl.dsp.window.center())
end

-- Speicher aufraeumen, wenn Fenster schliessen
hl.on("window.close", function(w) already_floated[w.address] = nil end)

hl.bind("SUPER + V", toggle_float_16_9)
