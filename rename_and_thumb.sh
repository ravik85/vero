#!/bin/bash

DIR="img/portfolio/kuchnie"
THUMB_DIR="$DIR/thumb"

# Check ImageMagick
if command -v magick &>/dev/null; then
  IM="magick"
elif command -v convert &>/dev/null; then
  IM="convert"
else
  echo "ERROR: ImageMagick not found. Install with: sudo pacman -S imagemagick"
  exit 1
fi

mkdir -p "$THUMB_DIR"

counter=1
while IFS= read -r -d '' file; do
  new_name="$DIR/${counter}.jpg"
  mv "$file" "$new_name"

  # Thumbnail: scale to max height 300px, keep aspect ratio
  $IM "$new_name" -resize "800x600>" "$THUMB_DIR/${counter}_t.jpg"

  echo "[$counter] $(basename "$file") -> ${counter}.jpg"
  ((counter++))
done < <(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | sort -z)

echo ""
echo "Done. Renamed $((counter - 1)) files. Thumbs saved to $THUMB_DIR"
