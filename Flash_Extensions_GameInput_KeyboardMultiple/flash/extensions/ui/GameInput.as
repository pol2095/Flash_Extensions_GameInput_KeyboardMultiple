/*
Copyright 2017 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package flash.extensions.ui
{
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.ui.GameInput;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.extensions.events.GameInputChangeEvent;
	
	/**
	 * Dispatched when a control is pressed or is continially pressed.
	 */
	[Event(name="change", type="flash.extensions.events.GameInputChangeEvent")]
	
	/**
	 * The GameInput class is the entry point into the GameInput API. You can use this API to manage the communications between an application and game input devices (for example: joysticks, gamepads, and wands).
	 *
	 * It can detect when a control is pressed continially.
	 */
	public class GameInput extends EventDispatcher
	{
		private var gameInput:flash.ui.GameInput;
		private var _device:GameInputDevice;
		private var timers:Vector.<Timer>;
		
		/**
		 * A list of controls pressed which must be detected.
		 */
		public var controlsDownContinially:Vector.<String> = new <String>[];
		
		private var _controlsDownDelay:int = 100;
		/**
		 * The delay, in milliseconds, when a control is continially pressed to dispatch a change event.
		 *
		 * @default 100
		 */
		public function get controlsDownDelay():int
		{
			return _controlsDownDelay;
		}
		public function set controlsDownDelay(value:int):void
		{
			_controlsDownDelay = value;
		}
		
		/**
		 * Initialize this class.
		 *
		 * <listing version="3.0">
		 * var gameInput:GameInput = new GameInput();
		 * gameInput.init();</listing>
		 */
		public function init():void
		{
			gameInput = new flash.ui.GameInput();
			gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
			
			timers = new Vector.<Timer>( controlsDownContinially.length );
			for(var i:int = 0; i < controlsDownContinially.length; i++)
			{
				timers[i] = new Timer( controlsDownDelay );
				timers[i].addEventListener(TimerEvent.TIMER, timerHandler);
			}
		}
		
		private function handleDeviceRemoved(event:GameInputEvent):void
		{
			dispatchEvent( new GameInputEvent(event.type, event.bubbles, event.cancelable, event.device) );
		}
		
		private function handleDeviceAttached(event:GameInputEvent):void
		{
			dispatchEvent( new GameInputEvent(event.type, event.bubbles, event.cancelable, event.device) );
			GameInputControlName.initialize(event.device);
			
			for(var k:Number=0;k<flash.ui.GameInput.numDevices;k++){
				_device = flash.ui.GameInput.getDeviceAt(k);
				_device.enabled = true;
				
				for (var i:Number = 0; i < _device.numControls; i++) {
					var control:GameInputControl = _device.getControlAt(i);
					control.addEventListener(Event.CHANGE, onChange);
				}
			}
		}	
		
		private function onChange(event:Event):void
		{
			var control:GameInputControl = event.target as GameInputControl;
			if(control.value > -0.1 && control.value < 0.1) return;
			for(var i:int = 0; i < controlsDownContinially.length; i++)
			{
				if( controlsDownContinially[i] == control.id )
				{
					var index:int = controlsDownContinially.indexOf( control.id );
					if( timers[ index ].running ) return;
					timers[ index ].start();
				}
			}
			dispatchEvent( new GameInputChangeEvent(GameInputChangeEvent.CHANGE, control) );
		}
		
		/**
		 * Indicates whether the current platform supports the GameInput API.
		 */
		public static function get isSupported():Boolean
		{
			return flash.ui.GameInput.isSupported;
		}
		
		/**
		 * Provides the number of connected input devices. When a device is connected, the GameInputEvent.DEVICE_ADDED event is fired.
		 */
		public static function get numDevices():int
		{
			return flash.ui.GameInput.numDevices;
		}
		
		/**
		 * Gets the input device at the specified index location in the list of connected input devices.
		 *
		 * The order of devices in the index may change whenever a device is added or removed. You can check the name and id properties on a GameInputDevice object to match a specific input device.
		 *
		 * @param index The index position in the list of input devices.
		 *
		 * @return The specified GameInputDevice.
		 *
		 * @throws RangeError When the provided index is less than zero or greater than (numDevices - 1).
		 */
		public static function getDeviceAt(index:int):GameInputDevice
		{
			return flash.ui.GameInput.getDeviceAt(index);
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			for(var i:int = 0; i < GameInput.numDevices; i++)
			{
				var device:GameInputDevice = GameInput.getDeviceAt(i);
				for(var j:int = 0; j < device.numControls; j++)
				{
					var control:GameInputControl = device.getControlAt(j);
					if(control.value <= -0.1 || control.value >= 0.1)
					{
						if( controlsDownContinially.indexOf( control.id ) == -1 ) continue;
						dispatchEvent( new GameInputChangeEvent(GameInputChangeEvent.CHANGE, control) );
					}
					else
					{
						var index:int = controlsDownContinially.indexOf( control.id );
						if( index != -1 ) timers[ index ].reset();
					}
				}
			}
		}
		
		/**
		 * Indicates whether a control is active (true) or inactive (false).
		 *
		 * @param id The id of a control.
		 *
		 * @param index The index position in the list of input devices.
		 */
		public static function isDown(id:String, index:int):Boolean
		{
			var isDown:Boolean;
			for(var i:int = 0; i < flash.ui.GameInput.numDevices; i++)
			{
				if( i != index ) continue;
				var device:GameInputDevice = flash.ui.GameInput.getDeviceAt(i);
				for(var j:int = 0; j < device.numControls; j++)
				{
					var control:GameInputControl = device.getControlAt(j);
					if(control.id != id) continue;
					if(control.value <= -0.1 || control.value >= 0.1) isDown = true;
				}
			}
			return isDown;
		}
		
		/**
		 * Retrieves a specific device from a control.
		 *
		 * @param control A control on an input device.
		 */
		public static function getDeviceIndex(control:GameInputControl):int
		{
			for(var i:int = 0; i < flash.ui.GameInput.numDevices; i++)
			{
				if( flash.ui.GameInput.getDeviceAt(i) == control.device) break;
			}
			return i;
		}
		
		/**
		 * Disposes all resources.
		 */
		public function dispose():void
		{
			for(var i:int = 0; i < controlsDownContinially.length; i++)
			{
				timers[i].removeEventListener(TimerEvent.TIMER, timerHandler);
				timers[i] = null;
			}
			timers = null;
			for(i = 0; i < GameInput.numDevices; i++)
			{
				var device:GameInputDevice = GameInput.getDeviceAt(i);
				for(var j:int = 0; j < device.numControls; j++)
				{
					var control:GameInputControl = device.getControlAt(j);
					control.removeEventListener(Event.CHANGE, onChange);
				}
			}
			gameInput.removeEventListener(GameInputEvent.DEVICE_ADDED, handleDeviceAttached);
			gameInput.removeEventListener(GameInputEvent.DEVICE_REMOVED, handleDeviceRemoved);
			gameInput = null;
		}
	}
}