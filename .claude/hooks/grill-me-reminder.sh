#!/usr/bin/env bash
# UserPromptSubmit hook: nudge Claude to run the grill-me skill when a prompt
# looks like a plan or decision. Stays silent for slash commands, short
# messages, and anything containing an opt-out phrase.

input=$(cat)
prompt=$(printf '%s' "$input" | jq -r '.prompt // ""')

case "$prompt" in
  /*) exit 0 ;;
esac

shopt -s nocasematch
if [[ "$prompt" == *"skip grill"* || "$prompt" == *"tanpa grill"* || "$prompt" == *"lanjut aja"* ]]; then
  exit 0
fi

if [ "${#prompt}" -lt 80 ]; then
  exit 0
fi

jq -n '{
  hookSpecificOutput: {
    hookEventName: "UserPromptSubmit",
    additionalContext: "Reminder: if this message presents a plan, strategy, campaign, launch, pricing, hiring, process change, or any decision with real money, time, or people at stake (not a simple question or routine task), invoke the grill-me skill first. Ask one question at a time, each with your recommended answer, before recommending or building. If we are already mid-grill, continue with the next question. Otherwise ignore this reminder."
  }
}'
