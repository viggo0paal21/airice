#!/usr/bin/env bash
# Waybar (unten links): "Playing: Kuenstler - Titel", sonst "Playing: nothing".
# Folgt playerctl live, braucht kein Intervall.
SEP=$'\x1f'

emit() {
  local status artist title player text
  IFS="$SEP" read -r status artist title player <<<"$1"
  if [[ -z "$title" || "$status" == "Stopped" ]]; then
    text="nothing"
  else
    text="$title"
    [[ -n "$artist" ]] && text="$artist - $title"
    [[ "$status" == "Paused" ]] && text="$text (paused)"
  fi
  jq -cn --arg t "$text" --arg p "${player:-}" '{text: $t, tooltip: $p, class: "playing"}'
}

emit ""
playerctl --follow metadata \
  --format "{{status}}${SEP}{{artist}}${SEP}{{title}}${SEP}{{playerName}}" 2>/dev/null |
while IFS= read -r line; do
  emit "$line"
done
