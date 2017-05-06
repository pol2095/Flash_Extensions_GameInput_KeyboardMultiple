/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package flash.extensions.ui
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.extensions.events.KeyboardEvent;
	
	/**
	 * Dispatched when a key is pressed or is continially pressed.
	 */
	[Event(name="keyDown", type="flash.extensions.events.KeyboardEvent")]
	
	/**
	 * The Keyboard class is used to build an interface that can be controlled by a user with a standard keyboard. You can use the methods and properties of the Keyboard class without using a constructor. The properties of the Keyboard class are constants representing the keys that are most commonly used to control games.
	 *
	 * It can detect when a key is pressed continially.
	 */
	public class Keyboard extends EventDispatcher
	{
		private var multipleKeyDown:Vector.<uint> = new <uint>[];
		private var stage:Stage;
		private var timers:Vector.<Timer>;
		
		/**
		 * A list of keys pressed which must be detected.
		 */
		public var keysDownContinially:Vector.<uint> = new <uint>[];
		
		private var _keysDownDelay:int = 100;
		/**
		 * The delay, in milliseconds, when a key is continially pressed to dispatch a change event.
		 *
		 * @default 100
		 */
		public function get keysDownDelay():int
		{
			return _keysDownDelay;
		}
		public function set keysDownDelay(value:int):void
		{
			_keysDownDelay = value;
		}
		
		/**
		 * Creates a new Keyboard instance.
		 *
		 * @param stage The native stage.
		 */
		public function Keyboard(stage:Stage)
		{
			this.stage = stage;
		}
		
		/**
		 * Initialize this class.
		 *
		 * <listing version="3.0">
		 * var keyboard:Keyboard = new Keyboard();
		 * keyboard.init();</listing>
		 */
		public function init():void
		{
			stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			
			timers = new Vector.<Timer>( keysDownContinially.length );
			for(var i:int = 0; i < keysDownContinially.length; i++)
			{
				timers[i] = new Timer( keysDownDelay );
				timers[i].addEventListener(TimerEvent.TIMER, timerHandler);
			}
		}
		
		private function keyDownHandler(event:flash.events.KeyboardEvent):void
		{
			var pressed:Boolean;
			var index:int = multipleKeyDown.indexOf( event.keyCode );
			if( index == -1 )
			{
				multipleKeyDown.push( event.keyCode );
			}
			else
			{
				pressed = true;
			}
			
			if( ! pressed )
			{
				index = keysDownContinially.indexOf( event.keyCode );
				if( index != -1 ) timers[ index ].start();
				dispatchEvent( new flash.extensions.events.KeyboardEvent( flash.extensions.events.KeyboardEvent.KEY_DOWN, event.keyCode ) );
			}
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			for(var i:int = 0; i < timers.length; i++)
			{
				if( event.currentTarget === timers[i] )
				{
					dispatchEvent( new flash.extensions.events.KeyboardEvent( flash.extensions.events.KeyboardEvent.KEY_DOWN, keysDownContinially[i] ) );
				}
			}
		}
		
		private function keyUpHandler(event:flash.events.KeyboardEvent):void {
			var index:int = multipleKeyDown.indexOf( event.keyCode );
            multipleKeyDown.splice( index, 1 );
			index = keysDownContinially.indexOf( event.keyCode );
			if( index != -1 ) timers[ index ].reset();
        }
		
		private function onDeactivate(event:Event = null):void
		{
			multipleKeyDown = new <uint>[];
			for(var i:int = 0; i < timers.length; i++) timers[i].reset();
		}
		
		/**
		 * Disposes all resources.
		 */
		public function dispose():void
		{
			stage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.removeEventListener(flash.events.KeyboardEvent.KEY_UP, keyUpHandler);
			stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			onDeactivate();
			for(var i:int = 0; i < keysDownContinially.length; i++)
			{
				timers[i].removeEventListener(TimerEvent.TIMER, timerHandler);
				timers[i] = null;
			}
			timers = null;
		}
	}
}