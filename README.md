# mc-independent-modpacks

This repository is a modpack for the new "Cobble Friends" server. Its based on https://github.com/xTamasu/mc-independent-modpacks to create a new modpack without hosting on platforms like modrinth or curseforge but with packwiz.

# Installing Packwiz

[Packwiz](https://github.com/packwiz) is a cli tool which is able to manage minecraft modpacks in a toml based way.

## Dependencies

- Docker (e.g. via Docker Desktop)
- CLI (currently only .ps1 supported)

## Configure PowerShell

Configure Powershell to allow the execution of remote signed code on this user.

Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` in a administative powershell.

## Installation

Build the Dockerfile and name the image `packwiz:latest`.

`docker build --pull --rm -f 'Dockerfile' -t 'packwiz:latest' '.'`

## Try it out!

Run `.\packwiz.ps1` to see an overview of available commands.

# Using Packwiz

For a offical documentation please refer to:

- https://packwiz.infra.link/
- https://packwiz.infra.link/reference/additional-options/

## File Structure

## Initialize a modpack

To initialize a modpack run `.\packwiz.ps1 init --name "MyModpack" --author "YourName"`

- `--name` the name of the modpack.
- `--author` the author of the modpack.

After that a small cli wizard will start and configure your modpack with minecraft version, which mod loader you want to use, etc.

You can also directly configure this via additional flags. For that please refer to https://packwiz.infra.link/reference/commands/packwiz/init/.

## Add mods

For a offical documentation please refer to https://packwiz.infra.link/tutorials/creating/adding-mods/.

### Modrinth

To add mods from modrinth run `.\packwiz.ps1 modrinth install <slug>/<id>/<url>`. You can either use the slug, url or id.

- **Slug:** [https://modrinth.com/mod/**sodium**](https://modrinth.com/mod/sodium) ->
`.\packwiz.ps1 modrinth install sodium`

- **Url:** `.\packwiz.ps1 modrinth install https://modrinth.com/mod/sodium`

- **Id:** [AANobbMI](https://modrinth.com/mod/sodium) ->
`.\packwiz.ps1 modrinth install AANobbMI`

### CurseForge

To add mods from curseforge run `.\packwiz.ps1 curseforge install <slug>/<modpage-url>/<filepage-url>`. You can either use the slug, mod page url or file page url.

- **Slug:** [https://www.curseforge.com/minecraft/mc-mods/**indium**](https://www.curseforge.com/minecraft/mc-mods/indium) -> `.\packwiz.ps1 curseforge install indium`

- **Mod Page Url:** ``.\packwiz.ps1 curseforge install https://www.curseforge.com/minecraft/mc-mods/indium``

- **File Page Url:** ``.\packwiz.ps1 curseforge install https://www.curseforge.com/minecraft/mc-mods/indium/files/3535202``

## Add config

For a offical documentation please refer to https://packwiz.infra.link/tutorials/creating/adding-mods/#internal-files-config-files-scripts-etc.

To distribute config you need to create a folder `config` at your `pack` folder. In this folder you need to place all the config which you want to distribute.

As distributing the config files directly causes a overwrite on the user side, always use the mod [DefaultOptions](https://github.com/TwelveIterationMods/DefaultOptions) so the configs are only initially set and not overwritten.

If you want to include additional files (e.g. mod configs) you need to include them in a `extra` folder within `defaultoptions`.

### DefaultOptions Example

Folder structure
````
/pack/config/
└───defaultoptions/
    │   keybindings.txt
    │   options.txt
    └───extra/
            xaerominimap.txt
````

---

keybindings.txt
````
key_key.jump:key.mouse.left:
````

Sets the jump action to the left mouse button.

---

options.txt
````
renderDistance:2
````

Sets the render distance to two chunks.

---

/extra/xaerominimap.txt
````
#CONFIG ONLY OPTIONS
ignoreUpdate:0
settingsButton:false
allowWrongWorldTeleportation:false
differentiateByServerAddress:true
debugEntityIcons:false
...
````

Sets the settings of the Xaero Minimap mod. *This example is not valid.*

---

## Distribute modpack

The prefered, legal, way to distribute modpacks without using modrinth, curseforge or hosting mods themselves is done via [packwiz-installer](https://packwiz.infra.link/tutorials/installing/packwiz-installer/).

This allows the java client itself to download the mods itself via a packwiz-installer-bootstrap. That means that you're not hosting the mod files but only redirect to the offical download.

### Serve pack index

You need a public webserver which serves the generated files in ``/pack`` from packwiz. 

Given that youre serving the ``pack.toml`` at http://mymodpack.com, you can open http://mymodpack.com/pack.toml at your webbrowser and see the value of your pack.toml file.

An example `docker-compose.yaml` can be found within this repository, which hosts a webserver serving the pack at http://localhost:8080/pack.toml.

### Prepare your client

You need a bootstrapped minecraft client to download the files itself.

Download the latest `packwiz-installer-bootstrap.jar` from [here](https://github.com/packwiz/packwiz-installer-bootstrap).

Add the `packwiz-installer-bootstrap.jar` to your .minecraft folder. Then add the bootstrap jar as a pre-execution command on your client.

You can do that e.g. by using **Prism Launcher**:

- 1. Create your instance using the currently correct minecraft and mod loader version. (They can be updated later on by the bootstrapper!)

- 2. Open the folder of the instance by right clicking on the instance then select `Folder`.

- 3. Put the `packwiz-installer-bootstrap.jar` into the ``/minecraft`` folder of this instance.

- 4. Add the bootstrapper as a pre-launch command by right clicking on the instance.

- - 4.1 Select `Edit`. 
    
- - 4.2 Navigate to `Settings`. 

- - 4.3 Choose the tab `Custom commands` and enable the checkbox `Custom Commands` 

- - 4.4 Insert `"$INST_JAVA" -jar packwiz-installer-bootstrap.jar http://mymodpack.com/pack.toml` into the `Pre-launch command` field. **Don't forget to change the url.**

Now you can distribute your Prism Launcher Modpack by right clicking the instance and select `Export Prism Launcher (zip)`.

A popup `Export instance` will be shown. Select all your required config but **nothing inside the minecraft folder** *besides* the **packwiz-installer-bootstrap.jar**. The required mods will be downloaded by the packwiz-installer from your provided url in the pre launch command.