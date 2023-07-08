package  {
	
	import flash.display.MovieClip;
	import flash.events.*
	import flash.utils.Timer;
	
	public class Square extends Enemy {
		
		var defaultSpeed:Number = ((Math.random() * 10) + 2);
		var maxHealth:Number = 4;
		var damageAmount:Number = 3;
		var shootTimer:Timer;
		var betweenShots:Timer;
		
		public function Square() {
			var frequency = (Math.random() * 1000);
			shootTimer = new Timer(frequency); //timer for bursts of bullets, shoots for 100 stops for 100 
			betweenShots = new Timer(randomNum(30,100),Infinity); //time between bullets
			health = maxHealth;
			speed = defaultSpeed;
			damage = damageAmount;
			canDamage = false; //cant dmaage player when hit just pushes slightly
			canShoot = false;
			pushStrength = 20; //pushes the player away slightly
			this.x = Math.random() * 1024; //randomises starting coords
			this.y = Math.random() * 768; 
			this.addEventListener(Event.ENTER_FRAME, move); //begins movement
			this.addEventListener(Event.ENTER_FRAME, hitPlayerCheck); //to see if touching the player
			betweenShots.addEventListener(TimerEvent.TIMER, shoot) //add timer event listeners ande star timers
			shootTimer.addEventListener(TimerEvent.TIMER, tryShoot);
			shootTimer.start();
			betweenShots.start();
		}
		function move(e):void {
			go();
		}
		function tryShoot(e:TimerEvent) {
			if (speed > 0) {
				speed = 0; //sets speed to 0 so that the enemy stops moving when it shoots
				canShoot = true;
			} else {
				speed = defaultSpeed; //sets speed back to original speed so enemy moves again
				canShoot = false;
			}
		}
		function takeDamage(amountToTake):void {
			if (health > 1) {
				health -= amountToTake;
			} else {
				kill();
			}
		}
		function kill():void { //removes enemy and all event listeners 
			if(onStage){ //used to tell whether or not the kill fucntion has been called before so it doesn't try more than once
				onStage = false;
				Main.score += 4;
				this.removeEventListener(Event.ENTER_FRAME, move);
				betweenShots.removeEventListener(TimerEvent.TIMER, shoot)
				shootTimer.removeEventListener(TimerEvent.TIMER, tryShoot);
				Main.lowLayer.removeChild(this);
				Main.enemyArray.removeAt(Main.enemyArray.indexOf(this));//removes this enemy from the enemy Array
			}
		}
	}
	
}
