import org.osflash.signals.Signal;
import asunit.framework.TestCase;

class org.osflash.signals.SignalDispatchNonEventTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalDispatchNonEventTest";
	
	public var completed:Signal;
	
	private var testString:String = "BEEFCAKE";
	
	public function SignalDispatchNonEventTest(testMethod:String)
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
	
	public function test_dispatch_zero_should_call_listener_with_zero():Void
	{
		completed = new Signal(Number);
		completed.add(addAsync(onZero, 10), this);
		completed.dispatch(0);
	}
	
	private function onZero(n:Number):Void
	{
		assertEquals(0, n);
	}
	
	////
	
	public function test_dispatch_String_should_call_listener_with_String():Void
	{
		completed = new Signal(String);
		completed.add(check_dispatch_String_should_call_listener_with_String, this);
		completed.dispatch(testString);
	}
	
	private function check_dispatch_String_should_call_listener_with_String(dispatchedString:String):Void
	{
		assertEquals(testString, dispatchedString); 
	}
}