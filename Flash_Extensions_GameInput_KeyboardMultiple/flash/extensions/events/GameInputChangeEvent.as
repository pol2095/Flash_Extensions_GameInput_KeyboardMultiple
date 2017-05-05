/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package flash.extensions.events
{
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	/**
	 * A event dispatched when a control is pressed or is continially pressed.
	 *
	 * @see flash.extensions.ui.GameInput
	 */
	public class GameInputChangeEvent extends Event
	{
		/**
		 * Dispatched when a control is pressed or is continially pressed.
		 */
		public static var CHANGE:String = "change";
		
		/**
		 * A control on an input device.
		 */
		public var gameInputControl:GameInputControl;

		public function GameInputChangeEvent(type:String, gameInputControl:GameInputControl, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.gameInputControl = gameInputControl;
		}

		override public function clone():Event
		{
			return new GameInputChangeEvent(type, this.gameInputControl, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("GameInputChangeEvent", "type", "gameInputControl", "bubbles", "cancelable");
		}
	}
}