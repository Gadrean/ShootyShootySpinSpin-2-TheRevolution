package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	
	public class Bullet extends MovieClip {
		
		var speed:Number;
		var dx:Number;
		var dy:Number;
		var noDamage:Timer;
		var bullet:Bullet;
		var caller;
		
		public function Bullet(shotBy) {
			caller = shotBy; //used to see what object shot this instance of the bullet
			bullet = this; //sets bullet variable to this for use in later functions
			speed = 15; 	//sets speed
			this.x = caller.x //moves this bullet to the object that created it
			this.y = caller.y
			this.rotation = caller.rotation; //change rotation to the same the the callers rotation
			this.addEventListener(Event.ENTER_FRAME, move); 
			this.addEventListener(Event.ENTER_FRAME, hitCheck);

		}
		function move(e:Event):void { //bullet movement
			doMath(); 
			y = y + dy;
			x = x + dx;
		}
		function doMath():void { //used to move the bullet in the direction that it is rotated towards
			dx = Math.cos(deg2rad(this.rotation)) * speed; 
			dy = Math.sin(deg2rad(this.rotation)) * speed;
		}
		function deg2rad(deg:Number):Number{ // converts useless degrees into useful radians
			return deg * (Math.PI / 180);
		}
		function hitCheck(e:Event) {
			for (var i = 0; i < Main.enemyArray.length; i++) { //loop through the entire  enemy array
				if (bullet.hitTestObject(Main.enemyArray[i]) && caller != Main.enemyArray[i]) { //if the bullet is touching value i in enemy array
					Main.enemyArray[i].takeDamage(1); //calls take damage function in the instance of the enemy that the bullet is touching (i)
					kill(); //calls bullet kill function
				}
			}
			if (bullet.hitTestObject(Main.player) && Main.player != caller) {
				Main.player.takeDamage(1);
				kill(); //calls bullet kill function
			}else if(Main.bossFight){
				if (bullet.hitTestObject(Main.helath) && Main.player == caller) {
					Main.helath.takeDamage(1);
					kill(); //calls bullet kill function
				}
			}else if(this.x < -10 || this.x > 1030 || this.y < -10 || this.y > 780) { //if the bullets outside the game area
				kill(); //calls bullet kill function
			}
		}
		function kill() {
			if(this.parent != null){
				this.removeEventListener(Event.ENTER_FRAME, move);
				this.removeEventListener(Event.ENTER_FRAME, hitCheck);
				this.parent.removeChild(this);				
			}
		}
	}
	
}