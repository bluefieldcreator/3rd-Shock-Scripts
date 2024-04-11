# Music for Arma Missions in 1 Minute

## STEP 1 - Make your mission!

Open the Eden editor and create a new mission file.

## STEP 2 - Open the mission folder!

On your top-left toolbar, press `scenario` and then `open scenario folder`

Alternatively; you can press `ALT+O`.

![Editor Img](https://media.discordapp.net/attachments/942035235879649301/1228122806970220655/image.png?ex=662ae57e&is=6618707e&hm=cc91336b7d02f18febdb86d7df2a9042ef2c6c6a3d01f4900153eac8f53dd047&=&format=webp&quality=lossless)
## Step 3 - Add your music!

Make a folder named `music` in your scenario folder, and place in there your music files on the `.ogg` format.

> **SUPER IMPORTANT!**
> MAKE SURE YOUR MUSIC FILE IS PROPERLY CONVERTED IN THE  .OGG FILE, ARMA 3 CANNOT PLAY .MP3 OR ANY OTHER FORMAT!

![enter image description here](https://media.discordapp.net/attachments/942035235879649301/1228123123287855217/image.png?ex=662ae5ca&is=661870ca&hm=462814b5a56ced62a1fe662413974974ad4cd961587ea5cf76642c60fdb67229&=&format=webp&quality=lossless)![enter image description here](https://media.discordapp.net/attachments/942035235879649301/1228123744979910727/image.png?ex=662ae65e&is=6618715e&hm=6d0d28ab93ab8c466976c9a3702f1892c21d315b379fa96688dd83aed431c4b6&=&format=webp&quality=lossless)
## Step 4 - Add your music to the 'configuration'
For Arma 3 to be able to find your music, you have to add it to a 'configuration file'. This config file is called `description.ext` and can contain all your mission setup.

Here's how we add music to this file;

### Step 4.1 - Creating the 'description.ext' file
Create a file named `description.ext`, make sure you have the option "show file extension" enabled in your file explorer to make sure your file is in the `.ext` format and not `.txt`.

> **TIP!**
> You can find the view settings under the "view" tab in the file explorer.
> 
> ![file explorer view settings](https://cdn.discordapp.com/attachments/942035235879649301/1228124323382956042/image.png?ex=662ae6e8&is=661871e8&hm=f185eb1e670bb522c43a582ee3cccbd69ac744c18352b5c7994206a37bd4a710&)


Once your file is created, it should look like this

![description.ext](https://cdn.discordapp.com/attachments/942035235879649301/1228124545177882645/image.png?ex=662ae71d&is=6618721d&hm=65564d0cac9c0d9477650383c98ce1f1b450c0300ef213e1d25e0f582a9fa5ac&)

### Step 4.2 - Adding 'cfgMusic'
cfgMusic means 'config music', and its the section of your `description.ext` file you want to work with.

Here is the template for 'cfgMusic'
```ext
class CfgMusic
{
	tracks[] = {};
	class MyIntro
	{
		// display name
		name = "My intro music";

		  // filename, volume, pitch
		sound[] = {
			"\music\filename.ogg", db + 0, 1.0
		};
	};
};
  ```
Lets go line by line!

First of all, we have the `tracks[] = {};` line, this line defines our 'track names' available for the editor. Its purely optional if you only plan to run the music through scripts.

`class MyIntro`

This is the first piece of code that's important to us, this is the class name given to our music asset and its what we'll use to play the music.

`name = "My Intro Music";`
This is the display name that can be used to find the song from the zeus perspective.

`sound[] =  {};`
This defines our actual music, where it is, and what volume we give it.

`"\music\filename.ogg", db + 0, 1.0`
This is our music filename and the volume we want to give it. 

`db` is the user's music volume, though if the user has music volume set to 0 it wont matter.

### Step 4.3 - Applying it to our mission

In my case, my music file is `omnis.ogg`, so my cfgMusic would look like this;
 ```
 class CfgMusic
{
	tracks[] = {};
	class Omnis
	{
		// display name
		name = "Omnis Song";

		  // filename, volume, pitch
		sound[] = {
			"\music\omnis.ogg", db + 0, 1.0
		};
	};
};
```

And that's it! Your mission now has a music file 'attached' to it.

## Step 5 - Playing the music in-game
Arma 3 offers a wide variety of ways to play your music in-game. The best option would be the `playMusic` command. (Ironic...)

The format is pretty simple; `playMusic musicClassName;`

In my case, my music class name is `Omnis`

>  **TIP**
>  Your music class name is NOT `name = "blah blah"`, its the `class NAME` what you're looking for! 

We can play this music through a trigger or anything similar, here's an example; A player walks into a trigger and "omnis" begins to play.

![Trigger](https://media.discordapp.net/attachments/942035235879649301/1228127156358483978/image.png?ex=662ae98b&is=6618748b&hm=8a547cb75d5174759f4847874e2ffd525a14353dae933d714f2c30ba5fd48188&=&format=webp&quality=lossless)

And that's it. 

> **TIP**
> Make sure to check out the 'bohemia wiki', they have an incredible ammount of **excellent** guides for mission making, scripting etc... and can teach you pretty much EVERYTHING there  is to know about SQF!
> https://community.bistudio.com/wiki/Introduction_to_Arma_Scripting


