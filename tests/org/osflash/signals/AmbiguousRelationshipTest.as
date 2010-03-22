import asunit.framework.TestCase;
import org.osflash.signals.Signal;

class org.osflash.signals.AmbiguousRelationshipTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalTest";
	
	private var completed:Signal;
	
	public function AmbiguousRelationshipTest(testMethod:String)
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

	public function test_add_then_addOnce_throws_error():Void
	{
		completed.add(failIfCalled, this);
		
		try { completed.addOnce(failIfCalled, this); }
		catch (e:Error) { return; }

		fail("Calling add then addOnce for the same listener should throw an error");
	}	
	
	private function failIfCalled():Void
	{
		fail("If this listener is called, something horrible is going on");
	}		
	
	////
	
	public function test_addOnce_then_add_throws_error():Void
	{
		completed.addOnce(failIfCalled, this);
		
		try { completed.add(failIfCalled, this); }
		catch (e:Error) { return; }

		fail("Calling addOnce then add for the same listener should throw an error");
	}
	
	////
	
	public function test_add_then_add_should_not_throw_error():Void
	{
		completed.add(failIfCalled, this);
		completed.add(failIfCalled, this);
		assertEquals(1, completed.numListeners);
	}
	
	////
	
	public function test_addOnce_then_addOnce_should_not_throw_error():Void
	{
		completed.addOnce(failIfCalled);
		completed.addOnce(failIfCalled);
		assertEquals(1, completed.numListeners);
	}
}