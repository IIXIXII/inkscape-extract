Inkscape Extract
===

This software is a small python program to create a batch that export images from an svg file created with inkscape.
You can parameter all the export inside the svg file itself.

1 - Create the svg file with inkscape
===

In order to prepare your svg file, you need to set the label in the property of some objects.
Property of svg object is accessible with the menu object. You will need to change some names. The picture below will show you the menu in inkscape ("Object" > "Property of the object")

![Property of svg object](doc/images/capture-1.PNG "Property menu")

The name of the object help the program to find the right element in the all svf file. 

Extracted object
---

The name for the extracted object is **picture**. The extracted object is the image you want to generate. Only the object is extracted, the object behind or somewhere else are not extracted.

![Name of the extracted object](doc/images/capture-2.PNG "picture")<!-- .element height="50%" width="50%" -->

Name of the file
---

The name for the filename of extracted object is **name**. Could you use folder in the name.
![Filename of the extracted object](doc/images/capture-3.PNG "name")

Commands for extraction
---

The list of the command object is name **command**. The list of the command is directly link to the command line of inkscape.

- **width**: The width of generated bitmap in pixels. 
- **height**: The height of generated bitmap in pixels.
- **background-opacity**: Opacity of the background of exported PNG. This may be a value either between 0.0 and 1.0 (0.0 meaning full transparency, 1.0 full

  opacity) or greater than 1 up to 255 (255 meaning full opacity).  
- **background**: Background color of exported PNG. This may be any SVG supported color string, rgb(255, 0, 128).
- **png**: export png
- **eps**: export eps
- **pdf**: export pdf
- *svg**: export svg
- **output_folder**: Define the output folder of the exported images.

  You can set many values separated by ";".

![command to extract the image](doc/images/capture-4.PNG "command")

Group (object, name, commands)
---

Finaly, group the name, the command and the picture to define the complet extraction. You can group all those object into a group object named **image**.
![group the all object](doc/images/capture-5.PNG "image")

Common commands for extraction
---

You can also group some commands in the object **general_command**.
![group some commands](doc/images/doc/images/capture-6.PNG "general_command")

2 - Create the batch to generate images
===

So with a right click you could launch the batch generator.
![Create the batch](doc/images/capture-10.PNG "Link to create the batch")

3 - Launch the batch and generate images
===

![Launch batch](doc/images/capture-7.PNG "batch launched")

![Generated pictures](doc/images/capture-8.PNG "generated pictures")

![Generated pictures](doc/images/capture-9.PNG "generated pictures")
