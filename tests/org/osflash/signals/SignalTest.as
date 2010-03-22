import asunit.framework.AsyncOperation;
import asunit.framework.TestCase;
import org.osflash.signals.Signal;

class org.osflash.signals.SignalTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalTest";
	
	private var completed:Signal;
	
	private var listenerDelegate:Function;
	
	private var numListenersBefore:Number;
	
	public function SignalTest(testMethod:String)
	{
		super(testMethod);
	}
	
	public function setUp():Void
	{
		completed = new Signal();
	}
	
	public function tearDown():Void
	{
		completed = null;
		listenerDelegate = null;
	}
	
	////
	
	public function test_numListeners_is_0_after_creation():Void
	{
		assertEquals(0, completed.numListeners);
	}
	
	////
	
	public function test_add_2_listeners_then_remove_1_should_yield_numListeners_of_1():Void
	{
		completed.add(function():Void { }, this);

		var secondListener:Function = function():Void { };
		completed.add(secondListener, this);
		completed.remove(secondListener, this);
		
		assertEquals(1, completed.numListeners);
	}
	
	////
	
	public function test_add_2_listeners_then_removeAll_should_yield_numListeners_of_0():Void
	{
		completed.add(function():Void { }, this);
		completed.add(function():Void { }, this);
		completed.removeAll();
		assertEquals(0, completed.numListeners);
	}
	
	////
	
	public function test_creating_signal_with_non_Function_parameters_throws_error():Void
	{
		var failSignal:Signal;

		try
		{
			failSignal = new Signal(new Date());
		}
		catch (e:Error)
		{
			return;
		}
		
		fail("Attempting to create a signal with non-Function parameters should throw an error.");
	}
	
	////
	
	public function test_add_same_listener_twice_should_add_it_once():Void
	{
		var emptyListener:Function = function():Void { };
		completed.add(emptyListener);
		completed.add(emptyListener);
		assertEquals(1, completed.numListeners);
	}
	
	////
	
	public function test_addOnce_same_listener_twice_should_add_it_once():Void
	{
		var emptyListener:Function = function():Void { };
		completed.addOnce(emptyListener);
		completed.addOnce(emptyListener);
		assertEquals(1, completed.numListeners);
	}
	
	////
	
	public function test_add_listener_and_dispatch_should_call_listener_with_object():Void
	{
		var eventObject:Object = { name:"beefcake" };
		
		completed.add(addAsync(check_event_with_name, 10), this);
		completed.dispatch(eventObject);

	}
	
	private function check_event_with_name(eventObject:Object):Void
	{
		var eventObjectName:String = "beefcake";
		assertEquals(eventObjectName, eventObject.name);
	}
	
	////
	
	public function test_add_two_listeners_then_dispatch_should_call_both():Void
	{
		var eventObject:Object = { name:"beefcake" };
		
		completed.add(addAsync(check_event_with_name, 10), this);
		completed.add(addAsync(check_event_with_name, 10), this);
		completed.dispatch(eventObject);
	}
	
	////
	
	public function test_add_2_listeners_remove_2nd_then_dispatch_should_call_1st_not_2nd_listener():Void
	{
		var eventObject:Object = { name:"beefcake" };
		
		completed.add(addAsync(check_event_with_name, 10), this);
		completed.add(failIfCalled, this);
		completed.remove(failIfCalled, this);
		completed.dispatch(eventObject);
	}
	
	////
	
	public function test_add_listener_then_remove_function_not_in_listeners_does_nothing():Void
	{
		completed.add(function():Void { } );
		completed.remove(function():Void { } );
		
		assertEquals(1, completed.numListeners);
	}
	
	////

	public function test_add_listener_then_remove_then_dispatch_should_not_call_listener():Void
	{
		completed.add(failIfCalled, this);
		completed.remove(failIfCalled,this);
		completed.dispatch();
	}

	private function failIfCalled():Void
	{
		fail("This event handler should not have been called.");
	}
	
	////
	
	public function test_dispatch_2_listeners_1st_listener_removes_itself_then_2nd_listener_is_still_called():Void
	{
		completed.add(remove_self, this);
		
		completed.add(addAsync(newEmptyHandler(), 10), this);
		
		completed.dispatch();
	}
	
	private function remove_self():Void
	{
		completed.remove(remove_self, this);
	}


	////
	
	public function test_dispatch_2_listeners_1st_listener_removes_2nd_listener_then_2nd_listener_is_still_called():Void
	{
		completed.add(remove_second_listener, this);
		
		listenerDelegate = addAsync(newEmptyHandler(), 10);
		completed.add(listenerDelegate, this);
		
		numListenersBefore = completed.numListeners;
		
		completed.dispatch();
	}
	
	private function remove_second_listener():Void
	{
		completed.remove(listenerDelegate, this);
	}
	
	////

	public function test_add_2_listeners_then_removeAll_then_dispatch_should_not_call_listeners():Void
	{
		completed.add(failIfCalled, this);
		completed.add(failIfCalled, this);
		completed.removeAll();
		completed.dispatch();
	}
	
	////

	public function test_dispatch_2_listeners_1st_listener_removes_all_then_2nd_listener_is_still_called():Void
	{
		completed.add(addAsync(remove_all_listeners, 10), this);
		completed.add(addAsync(newEmptyHandler(), 10), this);
		numListenersBefore = completed.numListeners;
		
		completed.dispatch();
	}
	
	private function remove_all_listeners():Void
	{
		completed.removeAll();
	}
	
	////

	public function test_add_listener_while_dispatching_does_not_call_new_listener():Void
	{
		completed.add(addAsync(add_listener_during_dispatch, 10), this);
		completed.dispatch();
	}
	
	private function add_listener_during_dispatch():Void
	{
		completed.add(failIfCalled, this);
	}
	
	////
	
	public function test_addOnce_then_dispatch_removes_listener():Void
	{
		completed.addOnce(newEmptyHandler(), this);
		completed.dispatch();
		assertEquals(0, completed.numListeners);
	}

	////
	
	public function test_addOnce_then_dispatch_calls_listener():Void
	{
		completed.addOnce(addAsync(newEmptyHandler(), 10), this);
		completed.dispatch();
	}
	
	////
	
	public function test_adding_2_listeners_using_addOnce_removes_both():Void
	{
		completed.addOnce(newEmptyHandler(), this);
		completed.addOnce(newEmptyHandler(), this);
		completed.dispatch();
		assertEquals(0, completed.numListeners);
	}

	////
	
	public function test_adding_2_listeners_using_addOnce_calls_both():Void
	{
		completed.addOnce(addAsync(newEmptyHandler(), 10), this);
		completed.addOnce(addAsync(newEmptyHandler(), 10), this);
		completed.dispatch();
	}
	
	////
	
	public function test_dispatching_wrong_object_throws_error():Void
	{
		var failSignal:Signal = new Signal(MovieClip);
		
		try
		{
			failSignal.dispatch(new Date());
		}
		catch (e)
		{
			return;
		}
		
		fail("Dispatching the wrong type of Object should throw an error.");
	}
	
	private function newEmptyHandler():Function
	{
		return function(e):Void { };
	}
}

