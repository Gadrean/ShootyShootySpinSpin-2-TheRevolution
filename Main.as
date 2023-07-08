package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.display.Sprite;

	public class Main extends MovieClip {

		public static var stageRef: Stage; //reference to the stage usable in other classes
		public static var healthCounter: HealthCounter = new HealthCounter; 
		public static var player: Player; //player 
		public static var tringle: Tringle; //tringle enemy 
		public static var square: Square; // square enemy
		public static var hexagonal: Hexagonal; // hexagonal enemy
		public static var menu: Menu; //menu screen
		public static var help: HelpScreen; //instructions screen
		public static var buttonCode: ButtonCode; //code that controls button functions
		public static var death: Death = new Death; //player dies screen
		public static var win:Win = new Win; //player wins screen
		public static var restart:Restart = new Restart; // restart button
		public static var helath:Helath; // Helath Boss enemy
		public static var finalScore:Score;
		
		public static var enemyArray: Array = new Array; //array that keeps track of enemies
		private static const enemyType: Array = new Array(Tringle, Square, Hexagonal); //list that contains all types of enemy 
		
		private static var waveTimer: Timer = new Timer(1000,2); //timer that controls when new waves appear and how many waves there are in total
		private static var enemySpawn: Timer; //time between when each enemy appears on screen 
		
		private static var enemyAmount: int; //controls the amount of enemies per wave
		
		public static var bossFight:Boolean = false; //used to tell if the boss is on stage
		public static var end:Boolean; //true if player or boss dies
		
		public static var score:Number;
		
		public static const topLayer:Sprite = new Sprite; //used to add objects above others
		public static const lowLayer:Sprite = new Sprite; //usd to add objects below others
		
		public function Main() {	//when main is first created		
			stageRef = stage;
			menu = new Menu;
			help = new HelpScreen;
			help.visible = false; 	//hides instructions
			restart.visible = false; 	//hides restart button
			this.addChildAt(lowLayer, 0); 	//adds lowLayer to stage
			this.addChild(topLayer);	//adds topLayer above lowLayer
			topLayer.addChild(menu);	//adds menu screen to stage
			topLayer.addChild(help);	//adds instructions screen to stage
			buttonCode = new ButtonCode; //runs buttonCode class
		}
		public static function initGame() { //when game starts or restarts
			end = false;  
			enemyAmount = 2; //sets or resets the amount of enemies in the first wave to two
			player = new Player(); //
			
			score = 0;
			player.x = stageRef.stageWidth / 2; //sets player start coords
			player.y = stageRef.stageHeight / 2;//sets player start coords
			player.rotation = 0; //sets rotation to zero
			restart.x = stageRef.stageWidth / 2; // sets restart button coords
			restart.y = 575; // sets restart button coords
			restart.visible = false; //makes restart button not visible
			topLayer.addChild(player); //adds player on to stage
			topLayer.addChild(healthCounter); //adds health counter on to stage
			topLayer.addChild(restart); //adds restart button on to stage
			healthCounter.x = healthCounter.width / 2; //sets coords
			healthCounter.y = healthCounter.height / 2; //sets coords

			stageRef.addEventListener(Event.ENTER_FRAME, enterFrame); //calls enterFrame function every frame
			waveTimer.addEventListener(TimerEvent.TIMER, wave); //calls wave function every time waveTimer reacehs 0ms 
			waveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, boss); // calls boss function when waveTimer ends/gets to last wave
		}
		private static function enterFrame(e: Event): void {	
			 if (enemyArray.length == 0 && !waveTimer.running) { //starts waveTimer when you kill all enemies in a wave
				waveTimer.start();
			}
			healthCounter.hp.text = String(player.playerHealth); //sets health counter text to players health
		}
		public static function helpScreen(addOrRemove) { //makes instructions visible or hidden 
			if (addOrRemove == 0) {
				help.visible = true;
			} else {
				help.visible = false;
			}
		}
		private static function wave(e: TimerEvent) {
			enemySpawn = new Timer(50, enemyAmount); //adds amount of enemies = enemyAmount every 50ms
			enemySpawn.addEventListener(TimerEvent.TIMER, spawn); // calls spawn fucntion when enemySpawn reaches 0
			enemySpawn.start(); //starts timer
			enemyAmount++; //increases enemyAmount by 1 (every wave has one more enemy)
		}
		private static function spawn(e: TimerEvent) { //calls addEnemy function and passes the value that getRandomElementOf returns
			addEnemy(getRandomElementOf(enemyType));
		}
		private static function getRandomElementOf(array: Array): Object {	//returns a random enemy from enemyType array
			return array[Math.floor(Math.random() * (array.length - 0.01))];
		}
		private static function addEnemy(enemyClass) { //adds enemy of whatever type was chosen above 
			var enemy = new enemyClass(); 
			enemyArray.push(enemy); //adds enemy to enemyArrray
			lowLayer.addChild(enemy); //adds enemy to stage
			waveTimer.stop(); //stops waveTimer
		}
		public static function boss(e: TimerEvent){ //called when waveTimer finishes
			waveTimer.reset(); //stops waveTimer and resets its values
			waveTimer.removeEventListener(TimerEvent.TIMER, wave); 			//removes waveTimer event listeners
			waveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, boss);
			helath = new Helath(); //runs Helath class
			topLayer.addChild(helath); // adds Health on Top of everything
			bossFight = true; //we're in the endGame now
		}
		public static function endGame(result): void {
			end = true; //player or boss dead
			waveTimer.reset();	//stops waveTimer and resets its values
			waveTimer.removeEventListener(TimerEvent.TIMER, wave); 			//removes eventListeners
			waveTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, boss); 
			stageRef.removeEventListener(Event.ENTER_FRAME, enterFrame);
			topLayer.removeChild(healthCounter); //removes health Counter from stage
			for (var i: int = enemyArray.length - 1; i >= 0; i--) { //goes through enemyArray and calls enemy Kill function
				enemyArray[i].kill();
			}
			if(result == "win"){ // if boss dead call player kill function and add win screen
				lowLayer.addChild(win);
				player.kill();
			} else { // otherwise add death screen
				lowLayer.addChild(death);
				if(bossFight){helath.kill();} //if in bossfight and player dies remove boss
			}
			restart.visible = true; // shwos restart button
			finalScore = new Score;
			finalScore.x = stageRef.stageWidth / 2;
			finalScore.y = 80;
			finalScore.playerScore.text = String(score);
			topLayer.addChild(finalScore);
		}
		public static function playAgain(): void { //removes anything left on stage and 
			topLayer.removeChildren();
			lowLayer.removeChildren();
			initGame();
		}
	}
}