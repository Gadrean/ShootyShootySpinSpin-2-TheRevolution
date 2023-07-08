package  { //each button would have this as their class right?
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class ButtonCode extends MovieClip { //class to control button actions
		
		public static var buttonWhiteList:Array; //contains button names
		private static var buttonClickFunctions:Array = [playGame, openHelp, closeHelp, restartClick];  //list of button function names
		
		public function ButtonCode() {
			buttonWhiteList = [Main.menu.playB, Main.menu.helpB, Main.help.backB, Main.restart]; // Button names
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, hoverChecker);
			Main.stageRef.addEventListener(MouseEvent.CLICK, click);
		}
		
		private function hoverChecker(e:Event){ //checks if the mouse if hovering over a button
			for(var i:Number = 0; i < buttonWhiteList.length; i++){ //goes through all the buttons in the array 
				if(buttonWhiteList[i].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, false)){ //if the mouse is touching a button in the array
					buttonWhiteList[i].gotoAndStop(2);//changes button appearance
				}else{
					buttonWhiteList[i].gotoAndStop(1);//otherwise normal button appearance
				}
			}
		}
		private static function click(e:MouseEvent){// if a mouse click is detected
			for(var i:Number = 0; i < buttonWhiteList.length; i++){ //goes through button array
				if(buttonWhiteList[i] == e.target){ //if number i in the array is the thing the mouse clicked
					buttonClickFunctions[i](); //calls the corresponding function 
				}
			}
		}
		
		private static function playGame(){ //start game
			Main.topLayer.removeChild(Main.menu);
			Main.initGame();
		}
		private static function openHelp(){ //open instructions
			Main.helpScreen(0);
		}
		private static function closeHelp(){ // hide instructions
			Main.helpScreen(1);
		}
		private static function restartClick(){ // restart game
			Main.playAgain();
		}

	}
	
}
