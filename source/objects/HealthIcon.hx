package objects;

import sys.FileSystem;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;

	public var defualtIconScale:Float = 1.0;
	public var iconScale:Float = 1.0;
	public var iconSize:Float = 128;

	var char:String;
	public var status:String = "normal";

	private var tween:FlxTween;

	private static final pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit"];

	public function new(char:String = 'face', isPlayer:Bool = false, ?_id:Int = -1)
	{
		super();
		flipX = isPlayer;

		changeChar(char);

		normal();

		antialiasing = !pixelIcons.contains(char);
		scrollFactor.set();

		tween = FlxTween.tween(this, {}, 0);
	}

	public function changeChar(char:String)
	{
		if (FileSystem.exists("mods/images/healthicons/" + char))
			this.char = char;
		else
			this.char = "face";
	}

	public function normal()
	{
		if (FileSystem.exists("mods/images/healthicons/" + char + "/normal.png"))
			loadGraphic(Paths.image("healthicons/" + char + "/normal"));
		status = "normal";
	}

	public function win()
	{
		if (FileSystem.exists("mods/images/healthicons/" + char + "/win.png"))
			loadGraphic(Paths.image("healthicons/" + char + "/win"));
		status = "win";
	}

	public function lose()
	{
		if (FileSystem.exists("mods/images/healthicons/" + char + "/lose.png"))
			loadGraphic(Paths.image("healthicons/" + char + "/lose"));
		status = "lose";
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();
	}


	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if (FileSystem.exists("mods/images/healthicons/" + char))
			this.char = char;
		else
			this.char = "face";
	}

	public function tweenToDefaultScale(_time:Float, _ease:Null<flixel.tweens.EaseFunction>)
	{
		tween.cancel();
		tween = FlxTween.tween(this, {iconScale: this.defualtIconScale}, _time, {ease: _ease});
	}


	public var autoAdjustOffset:Bool = true;
	public function getCharacter():String {
		return char;
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	override public function destroy()
	{
		tween = FlxDestroyUtil.destroy(tween);
		super.destroy();
	}
}
