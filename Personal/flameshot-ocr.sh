#! /bin/bash

available_langs=$(tesseract --list-langs 2>/dev/null)
available_langs=$(echo "$available_langs" | tail -n +2)

if [[ ! -z "$available_langs" ]]; then
  language=$(zenity --list --title="Available OCR Languages" \
                  --text="Choose language:" \
                  --column="Language" <<< "$available_langs")
else
  echo "No languages found for Tesseract."
fi

sleep 0.5
lang=${language:-vie}
flameshot gui --raw | tesseract stdin stdout -l $lang | xclip -in -selection clipboard
