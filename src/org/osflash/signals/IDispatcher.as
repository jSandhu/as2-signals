interface org.osflash.signals.IDispatcher
{
		/**
		 * Dispatches any number of parameters to listeners. Will be type-checked against valueClasses.
		 * @throws	Error	<code>Error</code>:	valueObjects are not compatible with valueClasses.
		 */
		function dispatch():Void
}