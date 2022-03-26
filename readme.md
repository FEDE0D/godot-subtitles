# Godot Subtitles

This is a sample project that includes the "SRT To Animation" plugin for Godot 3.

The project includes an ogv format video and srt subtitles both on spanish and english, imported into the scene using the SRTImporter node.

![image](https://user-images.githubusercontent.com/6296184/158704719-4d499719-4315-4420-b437-cba9829ec095.png)

## SRT To Animation Plugin

This plugin was created to help you work with subtitles inside Godot. It allowes you to import an srt format subtitle file into any scene.

It works by converting the SRT file into a Godot Animation Resource. This way you can use any AnimationPlayer and RichLabelText node to play the subtitle.

The reason behind using an Animation Resouce is to take advantage of the power of animations in Godot. Once the animation is created, all the information is compressed and managed by the engine just like any other resource.

## How to use?

Just import the "srt-animation" addon folder inside your project and enable the plugin inside the project manager.

Once you import the addon, you will find available the new  "SRTImporter" node.

This node will import the srt into any animation and richLabelText node that you have on your scene. You will have to setup some node properties first:

![image](https://user-images.githubusercontent.com/6296184/158704344-ae693616-ce44-4c7b-b558-bdb0bf68eb2f.png)

* SRT file: select any .srt file that you want to import
* Label node: the path to the RichTextLabel node where you want to show the subtitles
* AnimationPlayer node: the path to the AnimationPlayer node where you want to create the new animation
* Animation name: the name of the new animation. If an animation with the same name exists within the animation player, it will overwritten
* Animation step: this is the step used for the new animation, you will probably want to keep this on 0.001
* Alignment: forces an alignment on every line of the subtitle. Options are center, left, right and fill.
* Import animation: used to import the srt file into the animation player

Once you finished the setup of the SRTImported node you can click the "Import Animation" checkbox to import the srt file.

If you go to the animation player you will now see a new animation, where the tracks are animating the bbcode_text property of the richTextLabel node.

![image](https://user-images.githubusercontent.com/6296184/158704295-eff56e54-9c59-4f64-806e-2be1ed723b85.png)

## BBCode

This plugin works only with a RichTextLabel node, because it takes advantage of the bb code format available on this node to show formatted text.

Default srt formatting tags will be converted into BB code:

* \</b> will be converted to \[b] (bold text)
* \</i> will be converted to \[i] (italic text)
* \</u> will be converted to \[u] (underlined text)
* \<font color="#FF0000">...\</font> will be converted to \[color=#FF0000]...\[/color]

You can also use any SRT editor and add any custom BB Code tags into the subtitle, it will be converted correctly by the plugin. For example you can use the custom bb code tags from Godot:

* [wave][/wave]
* [rainbow][/rainbow]
* [url]
* any other [official bb code tags](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html)



## Contact me
My name is Federico Pacheco and you can reach me if at [github.com/fede0d](https://github.com/fede0d) you have any questions or ideas about the plugin.
