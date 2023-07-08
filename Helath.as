package  {
	
	import flash.display.MovieClip;
	import flash.events.*
	import flash.utils.Timer;
	
	public class Helath extends Enemy {
		
		var maxHealth:Number = 100;
		var damageAmount:Number = 10;
		var scaleBy:Number = 0.1;
		var healthBar:MovieClip;
		var hit:Timer = new Timer(50,9);
		
		public function Helath() { //sets variables to starting amounts 
			health = maxHealth;
			speed = 4;
			damage = damageAmount;
			this.x = 512;			//sets coordinates
			this.y = -this.width/2;
			this.addEventListener(Event.ENTER_FRAME, move); // begins movement
			
			healthBar = new HelathBar();
			Main.stageRef.addChild(healthBar); //creates and adds an instance of Healthbar to stage
			healthBar.gotoAndStop(healthBar.totalFrames); //goes to the last frame frame of healthbar
			healthBar.scaleX = 0.65; //sets health bar size
			healthBar.scaleY = 0.65;
		}
		function move(e:Event){ //sets Helath position and calls movement function(go);
			go();
			healthBar.x = this.x
			healthBar.y = this.y + 140
			
			if (this.hitTestPoint(Main.player.x, Main.player.y, true)) {
				if (scaleBy == 0.1){
					scaleBy = -0.1;
				}else {
					scaleBy = 0.1;
				}
				hit.reset();
				hit.addEventListener(TimerEvent.TIMER, change);
				hit.start();
			}
		}
		
		function change(e:TimerEvent){
			this.scaleX = this.scaleX + scaleBy;
			this.scaleY = this.scaleY + scaleBy;
		}

		function takeDamage(amountToTake):void {
			if (health > 1 ){ //has more than 1 health
				health -= amountToTake; //removes health
				if(healthBar.currentFrame - amountToTake >= 1){ //sets healthbar frame to health amount
					healthBar.gotoAndStop(healthBar.currentFrame - amountToTake);
				}else{ //makes sure it only goes to frame 1 doesnt try to go below
					healthBar.gotoAndStop(1);
				}
			} else {
				kill();
			}
		}
		function kill():void {
			if(onStage){ //used to tell whether or not the kill fucntion has been called before so it doesn't try more than once
				Main.score += 100;
				Main.bossFight = false; //used elsewhere to tell if the Helath should be removed or not
				onStage = false; 
				Main.stageRef.removeChild(healthBar); //removes healthbar
				this.removeEventListener(Event.ENTER_FRAME, move); //removes event listeners
				this.removeEventListener(Event.ENTER_FRAME, hitPlayerCheck);
				Main.topLayer.removeChild(this); //removes Helath from stage
				if(Main.end==false){Main.endGame("win");} //if the player is not dead used to show that the player won cause they killed Helath
			}
		}
	}
	
}