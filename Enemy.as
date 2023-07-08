package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Stage;
	import flash.utils.Timer;
	
	public class Enemy extends MovieClip{
		
		var dx:Number;
		var dy:Number;
		var speed:Number; //controls enemies speed
		var health:Number; //tracks enemies health
		var damage:Number; //controls amoutn of damage enymies deal
		var pushStrength:Number; //controls how much enemies pushplayer by
		var canHit:Boolean = true;
		var canDamage:Boolean; //used for the hitPlayer function to contorl whether the player takes damage or not only true for tringle enemies
		var hitTimer:Timer;
		var canShoot:Boolean;
		var onStage:Boolean;
		var bullet:Bullet;
		
		
		public function Enemy() {
			hitTimer = new Timer(50,1); 
			onStage = true;
		}
		public function go() { //all enemy movement
			var angle = Math.atan2(Main.player.y - this.y, Main.player.x - this.x) / (Math.PI/180); //gives angle to point the enemy in the players direction
			this.rotation = angle; //point at player
			doMath(); //
			this.y += dy; //moves enemy in direction of the player
			this.x += dx;	
		}
		function doMath():void {	
			dx = Math.cos(deg2rad(this.rotation)) * speed; //used to move the enemy in the direction its pointing towards
			dy = Math.sin(deg2rad(this.rotation)) * speed; 
		}
		function deg2rad(deg:Number):Number{ // convert degrees to radians
			return deg * (Math.PI / 180);
		}
		function hitPlayerCheck(e:Event):void{ //testingif the enemy hit the player 
			if(canHit) {
				if(this.hitTestPoint(Main.player.x, Main.player.y, true)){
					pushBack();
					if(canDamage){Main.player.takeDamage(damage);} //calls takedamage function in player class and provides the amount of damage to take

					canHit = false;
					hitTimer.addEventListener(TimerEvent.TIMER, hitCooldown); //restarts and resets hit cooldown
					hitTimer.reset();
					hitTimer.start();
				}
			}
		}
		function hitCooldown(e:TimerEvent):void{ //hit cooldown so the enemy can't hit the player over and over really fast
			canHit = true;
			hitTimer.removeEventListener(TimerEvent.TIMER, hitCooldown);
		}
		function pushBack():void { //pushes the player away in thesame direction the enemy is facing
			if (this.x > 0 && this.x < 1024 && this.y > 0 && this.y < 770) { //if on the screen area
				Main.player.x += Math.cos(deg2rad(this.rotation)) * pushStrength ;	
				Main.player.y += Math.sin(deg2rad(this.rotation)) * pushStrength ;
			}
		}
		function shoot(e:TimerEvent) { //creates and adds a new bullet instance to stage
			if (canShoot) {
				bullet = new Bullet(this); 
				Main.lowLayer.addChild(bullet); 
			}
		}
		function randomNum(min:Number, max:Number):Number { //gets a random number between min and max
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
	}	
}