Inkscape Extract
================

This software is a small python program to create a batch that export images from an svg file created with inkscape.
You can parameter all the export inside the svg file itself.

1 - Create the svg file with inkscape
-------------------------------------

In order to prepare your svg file, you need to set the label in the property of some objet.
Property of svg object is accessible with the menu object. You will need to change some names.
![Property of svg object](capture-1.PNG "Property menu")

The name for the extracted object is **picture**.
![Name of the extracted object](capture-2.PNG "picture")

The name for the filename of extracted object is **name**. Could you use folder in the name.
![Filename of the extracted object](capture-3.PNG "name")

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
 
![command to extract the image](capture-4.PNG "command")

Finaly, group the name, the command and the picture to define the complet extraction. You can group all those object into a group object named **image**.
![group the all object](capture-5.PNG "image")


You can also group some command in the object **general_command**








