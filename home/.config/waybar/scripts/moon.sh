#!/usr/bin/env bash
# Waybar (unten rechts): aktuelle Mondphase, rein gerechnet (kein Internet).
# Bezug: Neumond am 06.01.2000 18:14 UTC, ein Mondzyklus = 29.530588853 Tage.
now=$(date -u +%s)
awk -v now="$now" 'BEGIN {
  syn = 29.530588853
  age = ((now - 947182440) / 86400) % syn
  if (age < 0) age += syn
  split("New Moon|Waxing Crescent|First Quarter|Waxing Gibbous|Full Moon|Waning Gibbous|Last Quarter|Waning Crescent", n, "|")
  i = int(age / syn * 8 + 0.5) % 8 + 1
  light = (1 - cos(2 * 3.14159265 * age / syn)) / 2 * 100
  printf "{\"text\": \"%s\", \"tooltip\": \"%.0f %% lit, day %.1f of %.1f\"}\n", n[i], light, age, syn
}'
