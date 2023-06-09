# Loot Info - Container is empty or I already opened-looted it

## by JC Denton

## MOD Information

- **Origin**:           [Loot Info - Container is empty or I already opened-looted it](https://www.nexusmods.com/kingdomcomedeliverance/mods/491)
- **Author:**           [PaulDenton](https://www.nexusmods.com/kingdomcomedeliverance/users/1637891)
- **Updated by:**       [WileCoyote68](https://www.nexusmods.com/witcher3/users/3428152)
- **License:**          [Creative Commons | BY-NC-SA](LICENSE.md)
- **Version History:**  [Changelog](CHANGELOG.md)
- **Version:**          1.8.3
- **Date:**             2023/05/24
- **Category:**         User Interface

## MOD Description

Displays beside the **Loot/Open/Steal** interaction button whether the content is empty, already been opened or looted.

### Features

- The mod shows **(empty)** on the "loot/open/steal" button when the content is empty.
- It also displays **(dead)** or **(unconscious)** on the npc name.
- Localizations for Chinese/Czech/English/French/German/Italian/Polish/Russian and Spanish included.

Note: Already opened chests etc. (before this mod installed) are not displayed as "searched" after installation. You have to open it again, then the condition will be displayed correctly.

### Requirements

The requirement for [CLAM - Compatibility Localizations All Mods](https://www.nexusmods.com/kingdomcomedeliverance/mods/502) was removed since we now use table patching for all localization files

- At least **Kingdom Come: Deliverance v1.9.4** (because of table patching)

The mod won't start on older versions of the game.

### How to install with Vortex Mod Manger (VMM)

It's recommended to use **[Vortex Mod Manger](https://www.nexusmods.com/about/vortex/?)** with hard link deployment for installation. The mod has been optimized for this purpose.

- Get the file and save it to your desktop or your preferred location for downloaded files.
- Start **[Vortex Mod Manger](https://www.nexusmods.com/about/vortex/?)** and choose **MODS** in the menu on the left.
- On top in the menu bar click on the button install file.
- Choose the downloaded Zip file when prompted.

If **[Vortex Mod Manger](https://www.nexusmods.com/about/vortex/?)** is properly configured, you have completed the installation. No further steps required.

If you need help with **Vortex Mod Manager** visit the **[Nexus Mods Discord](https://discord.gg/nexusmods)**.

### How to uninstall with Vortex Mod Manger (VMM)

- Start **[Vortex Mod Manger](https://www.nexusmods.com/about/vortex/?)** and choose **MODS** in the menu on the left.
- Right click the mod in the list and choose remove/delete
- When prompted choose wether you want to delete the zip file or not.

### Manual Install

- Extract the downloaded ZIP file to your **..\KingdomComeDeliverance\Mods** folder

### Manual Uninstall

- Open Windows Explorer and navigate to your **..\KingdomComeDeliverance\Mods** folder
- Delete the Folder **LootInfo**

### Compatibility

Not compatible with mods that edit the following files:

<details>

<summary>Edited Files</summary>

- Data\Scripts\Entities\AI\Shared\BasicAIActions.lua
- Data\Scripts\Entities\AI\Boar_x.lua
- Data\Scripts\Entities\AI\Cow_x.lua
- Data\Scripts\Entities\AI\DeerDoe_x.lua
- Data\Scripts\Entities\AI\Dog_x.lua
- Data\Scripts\Entities\AI\Hare_x.lua
- Data\Scripts\Entities\AI\Hen_x.lua
- Data\Scripts\Entities\AI\Horse_x.lua
- Data\Scripts\Entities\AI\NPC_Female_x.lua
- Data\Scripts\Entities\AI\NPC_x.lua
- Data\Scripts\Entities\AI\Pig_x.lua
- Data\Scripts\Entities\AI\RedDeer_x.lua
- Data\Scripts\Entities\AI\RoeBuck_x.lua
- Data\Scripts\Entities\AI\Sheep_x.lua
- Data\Scripts\Entities\WH\AnimStash.lua
- Data\Scripts\Entities\WH\Nest.lua
- Data\Scripts\Entities\WH\StashCorpse.lua

</details>

If you plan to use **LootInfo** along with:

- [Lockpicking Overhaul](https://letsplaywithfire.com/releases/file/lockpicking-overhaul/) by [fireundubh](https://letsplaywithfire.com/about/)

be aware to load it after **LootInfo** (mod_order.txt in **KingdomComeDeliverance\Mods** required). The mod is fully compatible with [Perkaholic - PTF updated (1.9.4-1.9.6)](https://www.nexusmods.com/kingdomcomedeliverance/mods/1009) by [DarkDevil428](https://www.nexusmods.com/kingdomcomedeliverance/mods/1009)

### Patched Tables

<details>

<summary>Tables</summary>

- Localization\Chinese_xml\text_ui_ingame.xml
- Localization\Czech_xml\text_ui_ingame.xml
- Localization\English_xml\text_ui_ingame.xml
- Localization\French_xml\text_ui_ingame.xml
- Localization\German_xml\text_ui_ingame.xml
- Localization\Italian_xml\text_ui_ingame.xml
- Localization\Polish_xml\text_ui_ingame.xml
- Localization\Russian_xml\text_ui_ingame.xml
- Localization\Spanish_xml\text_ui_ingame.xml

</details>

### Credits

In alphabetic order:

- **[Cava1712](https://www.nexusmods.com/users/6435931)** for reporting the horse mounting bug
- **[daJbot](https://www.nexusmods.com/users/2222832)** from **Pyros Software:** Thanks for [Guidelines 2015 - ReadMe and Description Page generator](https://www.nexusmods.com/newvegas/mods/40278). Licensing/Legal
- **[FESilencer](https://www.nexusmods.com/users/10617840)** for reporting of 'Containers and NPCs seem to keep their searched tag even after re-spawning'
- **[figo283](https://www.nexusmods.com/users/52476851)** for looking after and updating my mod during my "absence"
- **[Frostmoon113](https://www.nexusmods.com/users/133261818)** for providing the latest fixes
- **[guven34](https://www.nexusmods.com/users/2435474)** Thanks for the bug report and your help to send me necessary files for review.
- **[lionroot](https://www.nexusmods.com/users/2034341)** Thanks for your help to send me necessary files for review.
- **[NiftyPower](https://www.nexusmods.com/users/11054808)** for reporting the horse mounting bug
- **[Valikon](https://www.nexusmods.com/users/3474366)** for the russian translation
- **[Warhorse Studios](https://warhorsestudios.cz/)** Thanks for this great game and for your help finding the solution for the "empty" feature.
- **[Wiwra](https://www.nexusmods.com/users/1707822)** for his help with the polish translation

# [![ModsInExile](https://github.com/wilecoyote/kcd-hsg/assets/1034673/dea5bd3c-d655-4838-8084-5643608f96d5)](https://discourse.modsinexile.com/)[![KCD Modding](https://github.com/wilecoyote/kcd-hsg/assets/1034673/3facff5e-f616-4aba-8749-1dec72f32a5c)](https://discord.gg/h89SS5VkvU "Join KCD Modding")
