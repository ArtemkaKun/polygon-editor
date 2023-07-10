<h1 align="center">Polygon Editor</h1>

<p align="center">
  <img src="https://github.com/ArtemkaKun/polygon-editor/assets/36485221/88afe641-bf52-4e08-8df5-7a09860652c5/polygoneditordemo.gif" alt="animated" />
</p>

## About

Polygon Editor is a desktop application designed for game developers to create and edit 2D polygon shapes to be used as colliders in their games. Compatible with Linux systems, it's built using the [V](https://vlang.io/) programming language and [V UI](https://github.com/vlang/ui) framework, offering a fast and lightweight tool. This project is open-source and is licensed under the MIT license.

## Key Features

- Sprite and Polygon loading: Load sprites (PNG) and existing polygons (JSON) for editing.
- Polygon drawing: Draw polygons on the loaded sprite by adding points with left mouse clicks.
- Point modification: Modify polygons by moving the points around.
- Point deletion: Remove points from the polygon via right-click.
- Status indications: Display status messages like "Polygon saved", "Sprite opened", etc.

## Usage

1. Begin by selecting a sprite that will serve as your reference for creating a polygon. You can do this by navigating to `File...` then selecting `Open sprite file`.
2. After your sprite is loaded, create a new polygon file. This can be done by going to `File...` and choosing `Create new polygon`.
3. You can now start shaping your polygon. Left-click with your mouse to add points. If you need to remove points, a right-click will do the trick. To reposition a point, simply press and hold the left mouse button and drag the point to your desired location.
4. Once you're satisfied with your polygon, ensure to save your work. Navigate to `File...` and then `Save polygon`. Your polygon will now be safely stored for future use or modification.

## User Interface

The UI consists of a panel bar at the top and a viewport. The panel bar includes a "File..." button that provides a dropdown menu with options for opening and saving sprites and polygons. The viewport displays the loaded sprite and the drawn polygon.

## Export

Export polygons as JSON files (`Polygon` structure from [v-2d-polygon-colliders](https://github.com/ArtemkaKun/v-2d-polygon-colliders) library). Each point is represented by an object (`Position` structure from [v-2d-transform](https://github.com/ArtemkaKun/v-2d-transform) library) with x and y properties for its coordinates.

> **Note**
> 
> It's crucial to remember that these point positions are not based on global coordinates, but rather they exist within the local space of the sprite used as a reference.
> This means that their position is defined relative to the origin point of the sprite, rather than the overall coordinate system.
> See [Local to Global](https://github.com/ArtemkaKun/polygon-editor/blob/8b6ac741194e540bae5f0def6c92e1733d8eb942/src/viewport/viewport.v#L82) and [Global to Local](https://github.com/ArtemkaKun/polygon-editor/blob/8b6ac741194e540bae5f0def6c92e1733d8eb942/src/viewport/viewport.v#L118) conversions examples.

```json
{
   "points":[
      {
         "Vector":{
            "x":0.05,
            "y":4.05
         }
      },
      {
         "Vector":{
            "x":1.0,
            "y":2.0
         }
      },
      {
         "Vector":{
            "x":3.05,
            "y":0.0
         }
      },
      {
         "Vector":{
            "x":7.0,
            "y":0.0
         }
      },
      {
         "Vector":{
            "x":8.05,
            "y":1.05
         }
      },
      {
         "Vector":{
            "x":9.1,
            "y":3.05
         }
      },
      {
         "Vector":{
            "x":13.05,
            "y":3.05
         }
      },
      {
         "Vector":{
            "x":14.0,
            "y":4.05
         }
      },
      {
         "Vector":{
            "x":15.05,
            "y":7.0
         }
      },
      {
         "Vector":{
            "x":15.05,
            "y":8.0
         }
      },
      {
         "Vector":{
            "x":12.05,
            "y":11.05
         }
      },
      {
         "Vector":{
            "x":9.0,
            "y":13.0
         }
      },
      {
         "Vector":{
            "x":3.05,
            "y":13.05
         }
      },
      {
         "Vector":{
            "x":0.9,
            "y":9.95
         }
      },
      {
         "Vector":{
            "x":0.0,
            "y":5.0
         }
      }
   ]
}
```

## Future Enhancements

- [ ] Dynamic zoom
- [ ] Undo/redo functionality
- [ ] Pixel precision grid

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## Donations

If you like this project, please consider donating to me or the V language project. Your donations will help me to continue to develop this project and the V language.

## More about my projects

Subscribe to [my Mastodon account](https://mastodon.social/@yuart) to find more info about my projects.
