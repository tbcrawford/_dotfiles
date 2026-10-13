# Push the Nord palette to terminals that don't ship it (T3, Terminal.app).
# Ghostty already uses `theme = Nord`.
status is-interactive; or return
isatty stdout; or return
test "$TERM_PROGRAM" = ghostty; and return

set -l nord_palette \
    3b4252 bf616a a3be8c ebcb8b 81a1c1 b48ead 88c0d0 e5e9f0 \
    596377 bf616a a3be8c ebcb8b 81a1c1 b48ead 8fbcbb eceff4

for i in (seq 16)
    printf '\e]4;%d;#%s\a' (math $i - 1) $nord_palette[$i]
end

# Foreground, background, cursor
printf '\e]10;#d8dee9\a\e]11;#2e3440\a\e]12;#eceff4\a'
