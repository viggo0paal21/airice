# Rice: Terminal-Look (Hyprland + Waybar)

Schlicht, eckig, Text statt Kaesten, JetBrainsMono Nerd Font, Schwarz-Weiss ohne Transparenz.
Nur Standard-Programme, die es lange geben wird: Hyprland, Waybar, rofi, swaync, hyprlock, kitty, awww/waypaper.
Kein eigenes Programm, keine Magie: jede Datei ist einzeln lesbar und aenderbar.

## Was wo liegt

| Teil | Datei | Neu laden |
|---|---|---|
| Fenster, Rahmen, Animationen, Tasten, Autostart | `~/.config/hypr/hyprland.lua` | speichern reicht |
| Leiste + Benachrichtigungen + Wallpaper starten | `~/.local/bin/rice-reload` (Logs: `~/.config/rice/logs`) | Super + Shift + R |
| Leiste oben + Infos unten | `~/.config/waybar/config.jsonc`, `style.css`, `scripts/` | style.css: speichern reicht. config: `pkill waybar; waybar &` |
| App-Launcher (Super + R) | `~/.config/rofi/config.rasi`, `rice.rasi` | beim naechsten Oeffnen |
| Power-Menue (Super + Escape, "power") | `~/.local/bin/rice-power` | sofort |
| Benachrichtigungen (Super + N) | `~/.config/swaync/config.json`, `style.css` | `swaync-client -rs` |
| Sperrbildschirm (Super + L) | `~/.config/hypr/hyprlock.conf` | beim naechsten Sperren |
| Terminal | `~/.config/kitty/kitty.conf`, Start mit fastfetch: `~/.local/bin/rice-shell/zsh` | Strg + Shift + F5 in kitty |
| Prompt `[viggo@archlinux ~]$` | `~/.config/starship.toml` | neue Shell |
| Kurzes fastfetch wie im Foto (beim Oeffnen von kitty) | `~/.config/fastfetch/rice.jsonc` | neues Terminal |
| Wallpaper | `~/Wallpapers/wallhaven-9omgp1-bw.png` (bunt: `-rice.png`), Wechseln mit Super + W (waypaper) | sofort |
| Wallpaper im Rice-Look erzeugen | `~/.local/bin/rice-wall` | – |

Alles, was vorher da war, liegt daneben als `*.bak-rice`.

## Farben

Schwarz-Weiss, keine Transparenz (alles deckend, kein Blur):

| Name | Farbe | Wofuer |
|---|---|---|
| fg | `#ffffff` | Text, aktiver Fensterrahmen, Unterstrich, Rahmen von rofi/swaync/hyprlock |
| subtle | `#8a8a8a` | Namen wie "mem:", "Playing:" |
| muted | `#5a5a5a` | leere Workspaces, "muted", Platzhalter |
| dim | `#333333` | inaktiver Fensterrahmen |
| bg | `#000000` | Leiste, Terminal, Menues, Sperrbildschirm |

Eine Farbe aendern: in `hypr/hyprland.lua` (oben `colors`), `waybar/style.css` (`@define-color`),
`waybar/config.jsonc` (`<span color>`), `rofi/rice.rasi`, `swaync/style.css`, `kitty/kitty.conf`, `hypr/hyprlock.conf`.

## Schrift

Ueberall `JetBrainsMono Nerd Font` (Paket `ttf-jetbrains-mono-nerd`). Groesse: Waybar `font-size` in style.css,
kitty `font_size`, rofi `font` in rice.rasi.

## Animationen

Ohne Animationen wirkt es tot, mit grossen (Zoom, Federn) passt es nicht zum schlichten Look. Darum hier:
alles kurz (100-200 ms), eine Kurve "snap" (schnell los, weich ankommen, kein Ueberschwingen).

- Fenster: blenden ein und wachsen dabei nur von 95 % auf 100 % (`popin 95%`)
- Workspaces: schieben sich nur 10 % zur Seite und blenden dabei ueber (`slidefade 10%`)
- Leiste, rofi, Menues: nur Einblenden; Benachrichtigungen gleiten von rechts rein
- Waybar: der Unterstrich und Hover-Farben blenden in 200 ms um
- kitty: kurze Cursor-Spur (`cursor_trail`), hyprlock blendet weich ein

Alle auf einmal: in `hyprland.lua` oben im Abschnitt TEMPO (wie die Farben bei FARBEN):
`local anim = { an = true, tempo = 1 }`. `tempo = 2` = alles doppelt so schnell, `0.5` = halb so schnell, `an = false` = aus.

Einzeln: im Abschnitt ANIMATIONEN, eine Zeile pro Animation:
`hl.animation({ leaf = "windowsIn", enabled = true, speed = 2 / anim.tempo, bezier = "snap", style = "popin 95%" })`
`speed` = Dauer in Zehntelsekunden bei tempo 1 (2 = 200 ms, kleiner = schneller). Kurven mit `hl.curve(...)`.
Wichtig bei der Lua-Config: Animationen gehen NUR so. Ein `animations = { bezier = ..., animation = ... }`
in `hl.config` wird ohne Fehlermeldung ignoriert (dann laufen Hyprlands langsame Standard-Animationen).
Mehr Bewegung: `popin 85%`, `slidefade 30%` oder `slide`. Gar keine: oben bei TEMPO `an = false`.

## Tasten

| Taste | Was |
|---|---|
| Super + Q | kitty |
| Super + R | App-Launcher |
| Super + E | Dateien |
| Super + C | Fenster schliessen |
| Super + V | Fenster schwebend in 16:9 |
| Super + L | sperren |
| Super + Escape | Power-Menue |
| Super + N | Benachrichtigungen |
| Super + W | Wallpaper waehlen |
| Super + Shift + S | Screenshot von einem Bereich |
| Super + 1-0 / Shift | Workspace / Fenster dorthin |
| Super + Shift + R | Leiste, Benachrichtigungen und Wallpaper neu starten (`rice-reload`) |
| Super + M | abmelden |

## Wallpaper im Rice-Look

`rice-wall BILD` macht aus einem Bild den Look aus dem Foto: dunkler grauer Verlauf, das Motiv als helle Zeilen.
Am besten mit Bildern mit dunklem Hintergrund und hellem Motiv (ASCII-Art, Schwarz-Weiss-Zeichnungen).
Ergebnis landet in `~/Wallpapers/` und taucht damit in waypaper auf. Optionen: `--color`, `--lines 0` (ohne Zeilen), `--invert`
(helles Bild, dunkles Motiv), `--fit` (ganzes Bild statt Bildschirm fuellen).

## Quickshell

Ist raus: nicht mehr im Autostart, keine Regeln mehr in hyprland.lua. Die Dateien liegen noch unberuehrt in
`~/.config/quickshell` und `~/.local/bin/qs-*`, gesichert im GitHub-Repo **Prism-Shell**.
Was Quickshells "App opacity" in kitty, Nautilus, Firefox, Vesktop und GTK3 eingestellt hatte, ist noch aktiv.
