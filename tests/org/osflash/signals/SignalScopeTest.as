import asunit.framework.TestCase;
import org.osflash.signals.Signal;

class org.osflash.signals.SignalScopeTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalScopeTest";
	
	private var completed:Signal;
	
	private var called:Boolean = false;
	
	public function SignalScopeTest(testMethod:String) 
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
	}
	
	////

	public function test_listener_retains_scope_on_dispatch():Void
	{
		var eventObject:Date = new Date();
		completed.add(check_listener_retains_scope_on_dispatch, this);
		completed.dispatch(eventObject);
	}
	
	private function check_listener_retains_scope_on_dispatch(eventObject:Date):Void
	{
		assertNotNull(this.className);
	}	
	
	////
	
	public function test_add_same_listener_twice_with_different_scopes_should_add_both():Void
	{
		var object1:Object = new Object();
		var object2:Object = new Object();
		
		object1.onComplete = onComplete;
		object2.onComplete = onComplete;
		
		completed.add(onComplete, object1);
		completed.add(onComplete, object2);
		
		assertEquals(2, completed.getNumListeners());
	}
	
	private function onComplete():Void
	{
		this.called = true;
	}
	
	////
	
	public function test_add_same_listener_twice_with_different_scopes_then_remove_first_removes_correct_listener():Void
	{		
		var object1:Object = {called:false};
		var object2:Object = {called:false};
		
		object1.onComplete = onComplete;
		object2.onComplete = onComplete;
		
		completed.add(onComplete, object1);
		completed.add(onComplete, object2);
		
		completed.remove(onComplete, object2);
		
		completed.dispatch();
		
		assertTrue(object1.called);
		assertFalse(object2.called);
	}
}