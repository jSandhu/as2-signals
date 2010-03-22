import asunit.framework.TestCase;
import org.osflash.signals.Signal;


class org.osflash.signals.SignalNoArgsTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalNoArgsTest";
	
	private var completed:Signal;
	
	private var listenerDelegate:Function;
	
	public function SignalNoArgsTest(testMethod:String)
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
	
	public function test_dispatch_no_args_should_call_listener_with_no_args():Void
	{
		completed.add(addAsync(onCompleted, 10), this);
		completed.dispatch();
	}
	
	private function onCompleted():Void
	{
		assertEquals(0, arguments.length)
	}
	
	////
	
	public function test_addOnce_in_handler_should_call_new_listener():Void
	{
		completed.addOnce(addAsync(addOnceInHandler, 10), this);
		completed.dispatch();
	}
	
	private function addOnceInHandler():Void
	{
		completed.addOnce(addAsync(secondAddOnceListener, 10), this);
		completed.dispatch();
	}
	
	private function secondAddOnceListener():Void
	{
	}
}