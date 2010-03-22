import org.osflash.signals.ISignal;
import org.osflash.signals.IDispatcher;

class org.osflash.signals.Signal implements ISignal, IDispatcher
{
	private var listenerBoxes:Array;
	
	private var _valueClasses:Array;
	
	private var listenersNeedCloning:Boolean = false;
	
	public function Signal()
	{
		listenerBoxes = [];
		
		// allow sub classes to pass an array of Classes
		//if (arguments.length == 1 && arguments[0] instanceof Array)
			//setValueClasses(arguments[0])
		//else
			setValueClasses(arguments);
	}
	
	public function get numListeners():Number { return listenerBoxes.length; }
	public function get valueClasses():Array { return _valueClasses; }
	
	public function add(listener:Function, scope:Object):Void
	{
		registerListener(listener, scope, false);
	}
	
	public function addOnce(listener:Function, scope:Object):Void
	{
		registerListener(listener, scope, true);
	}
	
	public function remove(listener:Function, scope:Object):Void
	{		
		if (listenersNeedCloning)
		{
			listenerBoxes = listenerBoxes.slice();
			listenersNeedCloning = false;
		}
		
		for (var i:Number = listenerBoxes.length; i--; )
		{
			if (listenerBoxes[i].listener == listener && listenerBoxes[i].scope == scope)
			{
				listenerBoxes.splice(i, 1);
				return;
			}
		}
	}
	
	public function removeAll():Void
	{
		// Looping backwards is more efficient when removing array items.
		for (var i:Number = listenerBoxes.length; i--; )
		{
			remove(listenerBoxes[i].listener, listenerBoxes[i].scope);
		}
	}
	
	public function dispatch():Void
	{
		var valueObject:Object;
		for (var n:Number = 0; n < _valueClasses.length; n++ )
		{
			if (typeof(arguments[n]) == "string" && _valueClasses[n] == String 
				|| typeof(arguments[n]) == "number" && _valueClasses[n] == Number)
				continue;
			
			if ((valueObject = arguments[n]) == null
				|| valueObject instanceof _valueClasses[n])
				continue;
				
			throw new Error('Value object <' + valueObject
					+ '> is not an instance of <' + _valueClasses[n] + '>.');
		}
		
		var listenerBoxes:Array = this.listenerBoxes;
		var len:Number = listenerBoxes.length;
		var listenerBox:Object;
		var scope:Object;
		listenersNeedCloning = true;
		for (var i:Number = 0; i < len; i++ )
		{
			listenerBox = listenerBoxes[i];
			if (listenerBox.once)
				remove(listenerBox.listener, listenerBox.scope);
				
			listenerBox.listener.apply(listenerBox.scope, arguments);
		}
		listenersNeedCloning = false;
	}
	
	private function setValueClasses(valueClasses:Array):Void
	{
		this._valueClasses = valueClasses || [];
		
		for (var i:Number = this._valueClasses.length; i--; )
		{
			if (!(this._valueClasses[i] instanceof Function))
				throw new Error('Invalid valueClasses argument: item at index ' + i
						+ ' should be a Class but was:<' + this._valueClasses[i] + '>.');
		}
	}
	
	private function registerListener(listener:Function, scope:Object, once:Boolean):Void
	{
		for (var i:Number = 0; i < listenerBoxes.length; i++ )
		{
			if (listenerBoxes[i].listener == listener && listenerBoxes[i].scope == scope)
			{
				if (listenerBoxes[i].once && !once)
					throw new Error('You cannot addOnce() then try to add() the same listener ' +
						'without removing the relationship first.');
				else if (once && !listenerBoxes[i].once)
					throw new Error('You cannot add() then addOnce() the same listener ' +
						'without removing the relationship first.');
				return;
			}
		}
		if (listenersNeedCloning)
		{
			listenerBoxes = listenerBoxes.slice();
		}
			
		listenerBoxes.push( { listener:listener, scope:scope , once:once } );
	}
}