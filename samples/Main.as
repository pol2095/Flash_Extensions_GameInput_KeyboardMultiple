package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.extensions.ui.GameInput;
	import flash.extensions.events.GameInputChangeEvent;
	import flash.display.Shape;
	import flash.extensions.ui.Keyboard;
	import flash.extensions.events.KeyboardEvent;
	
	public class Main extends Sprite
	{
		private var gameInput:GameInput;
		private var child:Shape = new Shape();
		
		public function Main()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			gameInput = new GameInput();
			gameInput.controlsDownContinially = new <String>["BUTTON_16", "BUTTON_17", "BUTTON_18", "BUTTON_19", "AXIS_0", "AXIS_1"];
			gameInput.controlsDownDelay = 50;
			gameInput.init();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
			
			var keyboard:Keyboard = new Keyboard(stage);
			keyboard.keysDownContinially = new <uint>[37, 38, 39, 40];
			keyboard.keysDownDelay = 50;
			keyboard.init();
			keyboard.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			
            child.graphics.beginFill(0x000000);
            child.graphics.drawCircle(200, 200, 50);
            child.graphics.endFill();
            this.addChild(child);
		}
		
		
		protected function handleDeviceRemoved(event:GameInputEvent):void
		{
			trace("Device is removed\n");
		}
		
		protected function handleDeviceAttached(event:GameInputEvent):void
		{
			trace("Device is added\n");
			gameInput.addEventListener(GameInputChangeEvent.CHANGE, onChange);
		}	
		
		protected function onChange(event:GameInputChangeEvent):void
		{
			var control:GameInputControl = event.gameInputControl;
			trace("The pressed control is " +control.name+" with id: "+control.id +" value "+control.value+" \n");
			
			/*var index:int = GameInput.getDeviceIndex( control );
			if(control.id == "BUTTON_6")
			{
				if( GameInput.isDown( "BUTTON_5", index ) )
				{
					trace("isDown control "+index+" : "+control.id+" and "+"BUTTON_5\n");
				}
			}*/
			//trace( GameInput.isSupported, GameInput.numDevices );
			changeHandler( control.id, control.value );
		}
		
		private function changeHandler(id:String, value:Number):void
		{
			switch(id) 
			{ 
				case "BUTTON_16":
					child.y -= value * 2; 
					break;
				case "BUTTON_17":
					child.y += value * 2; 
					break;
				case "BUTTON_18":
					child.x -= value * 2; 
					break;
				case "BUTTON_19":
					child.x += value * 2; 
					break;
				case "AXIS_0":
					child.x += value * 5; 
					break;
				case "AXIS_1":
					child.y -= value * 5; 
					break;
				case "BUTTON_4":
					child.graphics.clear();
					child.graphics.beginFill(0x00FF00);
					child.graphics.drawCircle(200, 200, 50);
					child.graphics.endFill();
					break;
				case "BUTTON_6":
					child.graphics.clear();
					child.graphics.beginFill(0x0000FF);
					child.graphics.drawCircle(200, 200, 50);
					child.graphics.endFill();
					break;
				case "BUTTON_7":
					child.graphics.clear();
					child.graphics.beginFill(0xFFFF00);
					child.graphics.drawCircle(200, 200, 50);
					child.graphics.endFill();
					break;
				case "BUTTON_5":
					child.graphics.clear();
					child.graphics.beginFill(0xFF0000);
					child.graphics.drawCircle(200, 200, 50);
					child.graphics.endFill();
					break;
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{ 
				case 38:
					changeHandler( "BUTTON_16",  1 );
					break;
				case 37:
					changeHandler( "BUTTON_18",  1 );
					break;
				case 40:
					changeHandler( "BUTTON_17",  1 );
					break;
				case 39:
					changeHandler( "BUTTON_19",  1 );
					break;
				case 65:
					changeHandler( "BUTTON_4",  1 );
					break;
				case 66:
					changeHandler( "BUTTON_5",  1 );
					break;
				case 88:
					changeHandler( "BUTTON_6",  1 );
					break;
				case 89:
					changeHandler( "BUTTON_7",  1 );
					break;
			}
		}
	}
}