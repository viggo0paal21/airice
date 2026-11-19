-- ==========================================================================
--  system.lua - Hintergrund-Kram, damit Apps richtig laufen und aussehen
--  Herausgeloest aus der alten KI-hyprland.lua (Stand 19.11.2026).
--
--  Einbinden: in deiner hyprland.lua ganz oben diese Zeile:
--      require("system")
--  Ohne diese Datei fehlen z. B. Passwort-Fenster fuer Admin-Aktionen,
--  und Qt-Apps verlieren den Schwarz-Weiss-Look.
-- ==========================================================================


----------------------------
---- UMGEBUNGSVARIABLEN ----
----------------------------

-- Gelten erst nach dem naechsten Einloggen.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- GTK-Apps: Blur-Protokoll aus (wird beim Start auch an dbus/systemd weitergegeben, siehe AUTOSTART)
hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")

-- Qt-Apps im Schwarz-Weiss-Look: Kvantum-Theme "MonochromeSolid", eingestellt in qt6ct
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- GTK-Apps dunkel, Dateidialoge ueber das Portal
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")
hl.env("ADW_DISABLE_PORTAL", "1")
hl.env("GTK_USE_PORTAL", "1")


-------------------
---- AUTOSTART ----
-------------------

-- Laeuft nur beim Einloggen.
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd GDK_WAYLAND_DISABLE")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")  -- Passwort-Fenster fuer Admin-Aktionen
    hl.exec_cmd("sleep 3 && arch-update --tray")           -- Update-Symbol im Tray
end)


---------------
---- FIXES ----
---------------

hl.config({
    misc = {
        force_default_wallpaper = 0,   -- kein Hyprland-Maskottchen als Wallpaper
    },
})

-- Apps duerfen sich nicht selbst maximieren
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
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
