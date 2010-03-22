import asunit.framework.TestCase;
import org.osflash.signals.ISignal;
import org.osflash.signals.IDispatcher;
import org.osflash.signals.Signal;

class org.osflash.signals.SignalSplitInterfacesTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalSplitInterfacesTest";	
	
	// Notice the use of the ISignal interface, rather than Signal.
	// This makes dispatch() inaccessible unless the ISignal is cast to IDispatcher or Signal.
	public var completed:ISignal;	
	
	public function SignalSplitInterfacesTest(testMethod:String)
	{
		super(testMethod);
	}
	
	public function setUp():Void
	{
		completed = new Signal()
	}
	
	public function tearDown():Void
	{
		completed = null;
	}
	
	public function test_cast_ISignal_to_IDispatcher_and_dispatch():Void
	{
		completed.addOnce( addAsync(onCompleted, 10), this );
		IDispatcher(completed).dispatch();
	}
	
	private function onCompleted():Void
	{
		assertEquals(0, arguments.length);
	}

	////
	
	public function test_cast_ISignal_to_Signal_and_dispatch():Void
	{
		completed.addOnce( addAsync(onCompleted, 10), this );
		Signal(completed).dispatch();
	}	
}