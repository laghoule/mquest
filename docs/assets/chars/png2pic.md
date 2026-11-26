# Generate tilesets of characters

Some characters use a predefined tileset in png format. We use png2pic to extract the png in a raw pic tileset.

## Mia

```sh
cd raw/characters/mia/custom/
png2pic -src F_01.png -dst mia.pic -tileSize 16x17
```

## Grandma

```sh
cd raw/characters/grandma/custom/
png2pic -src F_12.png -dst mia.pic -tileSize 16x17
```
