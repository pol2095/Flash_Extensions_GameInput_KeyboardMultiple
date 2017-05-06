/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package flash.extensions.events
{
	import flash.events.Event;
	
	/**
	 * A event dispatched when a key is pressed or is continially pressed.
	 *
	 * @see flash.extensions.ui.Keyboard
	 */
	public class KeyboardEvent extends Event
	{
		/**
		 * Dispatched when a key is pressed or is continially pressed.
		 */
		public static var KEY_DOWN:String = "keyDown";
		
		/**
		 * The key code value of the key pressed or continially pressed.
		 *
		 * <strong>Note:</strong> When an input method editor (IME) is running, keyCode does not report accurate key codes.
		 */
		public var keyCode:uint;

		public function KeyboardEvent(type:String, keyCode:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.keyCode = keyCode;
		}

		override public function clone():Event
		{
			return new KeyboardEvent(type, this.keyCode, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return formatToString("KeyboardEvent", "type", "keyCode", "bubbles", "cancelable");
		}
	}
}