package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	public class Player extends MovieClip{
		
		public var keyStates:Dictionary = new Dictionary();
		private const acceptedKeys:Array = [65, 68, 83, 87]; // keys that do anything in game
		var maxHealth:Number = 100; //starting health
		var playerHealth:Number; 
		var defaultSpeed:Number = 10; //starting speed 
		var playerSpeed:Number;
		var dx:Number;
		var dy:Number;
		var angle:Number; 
		var bullet:Bullet;
		var onStage:Boolean = true;
		
		public function Player() {
			this.addEventListener(Event.ADDED_TO_STAGE, init); //when this is actually added to stage call init function
		}
		function init(e:Event):void { //adds event listeners
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			Main.stageRef.addEventListener(Event.ENTER_FRAME, aim); 
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, keyPress);
			Main.stageRef.addEventListener(KeyboardEvent.KEY_UP, keyRelease);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, shoot); 
			playerHealth = maxHealth;
			this.
			playerSpeed = defaultSpeed;
			for(var i:Number = 1; i <= acceptedKeys.length; i++){
				keyStates[acceptedKeys[i-1]] = [0];
			}
		}
		function keyPress(e:KeyboardEvent):void {
			if(acceptedKeys.indexOf(e.keyCode) > -1){keyStates[e.keyCode] = 1;}
		}
		function keyRelease(e:KeyboardEvent):void {
			if(acceptedKeys.indexOf(e.keyCode) > -1){keyStates[e.keyCode] = 0;}
		}
		function aim(e):void { //used to move player and point at mouse
			
			if(keyStates[65] == 1 && this.x > 0){this.x -= playerSpeed;}//left
			if(keyStates[68] == 1 && this.x < 1024){this.x += playerSpeed;}//right
			if(keyStates[83] == 1 && this.y < 770){this.y += playerSpeed;}//down
			if(keyStates[87] == 1 && this.y > 0){this.y -= playerSpeed;}//up
			
			if(!this.hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true)) { //if player isn't touching the mouse
				angle = Math.atan2(Main.stageRef.mouseY - this.y, Main.stageRef.mouseX - this.x) / (Math.PI / 180); //gets the angle that points towards the mouse
				this.rotation = angle;
			}
		}
		function shoot(e:MouseEvent):void {
				bullet = new Bullet(Main.player); // bullet var is of type Bullet and creates a new instance of Bullet
				//Main.bulletArray.push(bullet);
				Main.lowLayer.addChild(bullet); //adds bullet instance underneath the playe
		}
		function takeDamage(damageAmount):void {
			if (playerHealth > 0){ //player still has health
				playerHealth -= damageAmount; //reduce by damage amount
			} else {
				kill();
			}
		}
		function kill():void { //removes player and all event listeners
			if(onStage){ //used to tell whether or not the kill fucntion has been called before so it doesn't try more than once
				onStage = false;
				Main.stageRef.removeEventListener(Event.ENTER_FRAME, aim);
				Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, keyPress);
				Main.stageRef.removeEventListener(KeyboardEvent.KEY_UP, keyRelease);
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, shoot);
				Main.topLayer.removeChild(this);
				if(Main.end==false){Main.endGame("lose");} //if the game is still going/Helath is alive then sets endGame variable to lose
			}
		}
	}
}