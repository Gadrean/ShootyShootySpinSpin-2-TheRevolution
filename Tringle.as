package  {
	
	import flash.display.MovieClip;
	import flash.events.*

	
	public class Tringle extends Enemy{
		
		var maxHealth:Number = 2;
		var damageAmount:Number = 1;
		
		public function Tringle() {
		pushStrength = randomNum(20,60);
			health = maxHealth;
			speed = randomNum(8,10); //slightly randomises speed of this enemy               
			damage = damageAmount;
			canDamage = true; // can damage the player when they hit  them because very pointy triangle
			this.x = Math.random() * 1024; //randomoises starting location
			this.y = Math.random() * 768;
			this.addEventListener(Event.ENTER_FRAME, move);
			this.addEventListener(Event.ENTER_FRAME, hitPlayerCheck); //to see if touching the player
		}
		function move(e:Event){
			go();
		}
		function takeDamage(amountToTake):void {
			if (health > 1) {
				health -= amountToTake;
			} else {
				kill();
			}
		}
		function kill():void {
			if(onStage){ //used to tell whether or not the kill fucntion has been called before so it doesn't try more than once
				onStage = false;
				Main.score += 3;
				this.removeEventListener(Event.ENTER_FRAME, move);
				this.removeEventListener(Event.ENTER_FRAME, hitPlayerCheck);
				Main.lowLayer.removeChild(this);
				Main.enemyArray.removeAt(Main.enemyArray.indexOf(this));//removes this enemy from the enemy Array
			}
		}
	}
	
}
