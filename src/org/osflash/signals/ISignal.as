interface org.osflash.signals.ISignal
{
		/**
		 * Get array of classes defining the types of parameters sent to listeners.
		 */
		function getValueClasses():Array;
		
		/** Get the current number of listeners for the signal. */
		function getNumListeners():Number;
		
		/**
		 * Subscribes a listener for the signal.
		 * @param	listener A function with arguments that matches the value classes dispatched by the signal.
		 * @param	scope The Object that is the function's scope.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 */
		function add(listener:Function, scope:Object):Void;
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called,
		 * after the dispatch to all listeners is complete.
		 * @param	listener A function with arguments that matches the value classes dispatched by the signal.
		 * @param	scope The Object that is the function's scope.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 */
		function addOnce(listener:Function, scope:Object):Void;
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 * @param	scope
		 */
		function remove(listener:Function, scope:Object):Void;
}