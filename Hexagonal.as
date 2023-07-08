package  {
	
	import flash.display.MovieClip;
	import flash.events.*
	import flash.utils.Timer;
	
	public class Hexagonal extends Enemy {
			
		var maxHealth:Number = 6; //starting health
		var damageAmount:Number = 10; //amount of damage Hexagonal enemies do
		var shootTimer:Timer; //timer between bursts of bullets and to control length of bursts
		var betweenShots:Timer = new Timer(20,Infinity); //time between bullets
		
		public function Hexagonal() {
			var frequency = (Math.random() * 1000); //randomises shootTimer
			shootTimer = new Timer(frequency,Infinity); //timer for bursts of bullets
			health = maxHealth; //resets health
			damage = damageAmount; //resets damage amount		prolly unnecessary
			speed = 0; //sets the speed to 0 as this enemy doesnt move
			canShoot = false; //variable that controls whether or not the enemy is shooting
			canDamage = false;
			this.x = Math.random() * 1024; //randomises Hexagonal starting position
			this.y = Math.random() * 768;
			this.addEventListener(Event.ENTER_FRAME, move); //calls movement function to make the enemy point towards the player
			betweenShots.addEventListener(TimerEvent.TIMER, shoot) //starts event listeners and timers
			shootTimer.addEventListener(TimerEvent.TIMER, tryShoot);
			shootTimer.start();
			betweenShots.start();
		}
		function move(e):void { //starts movement although speed = 0 so it just turns
			go();
		}
		function tryShoot(e:TimerEvent) { //controls bursts of bullets
			if (canShoot) { //switches back and forth after every time the timer reaches 0
				canShoot = false; 
			} else {
				canShoot = true;
			}
		}
		function takeDamage(amountToTake):void { //
			if (health > 1) { //if enemy still has health
				health -= amountToTake; //removes some health
			} else {
				kill(); //call kill fucntion
			}
		}
		function kill():void {
			if(onStage){ //used to tell whether or not the kill fucntion has been called before so it doesn't try more than once
				onStage = false;
				Main.score += 6;
				this.removeEventListener(Event.ENTER_FRAME, move); //removes event listeners 
				betweenShots.removeEventListener(TimerEvent.TIMER, shoot);
				shootTimer.removeEventListener(TimerEvent.TIMER, tryShoot);
				Main.lowLayer.removeChild(this) //removes this enemy
				Main.enemyArray.removeAt(Main.enemyArray.indexOf(this));//removes this enemy from the enemy Array 
			}
		}
	}
	
}