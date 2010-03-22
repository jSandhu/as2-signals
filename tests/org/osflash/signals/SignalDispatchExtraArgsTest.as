import asunit.framework.TestCase;
import org.osflash.signals.Signal;

class org.osflash.signals.SignalDispatchExtraArgsTest extends TestCase
{
	public var className:String = "org.osflash.signals.SignalDispatchExtraArgsTest";
	
	private var completed:Signal;
	
	public function SignalDispatchExtraArgsTest(testMethod:String)
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
	
	public function test_dispatch_extra_args_should_call_listener_with_extra_arga():Void
	{
		completed.add(addAsync(onCompleted, 10), this);
		completed.dispatch(22, 'done', new Date());
	}
	
	private function onCompleted(a:Number, b:String, c:Date):Void
	{
		assertEquals(3, arguments.length);
		assertEquals(22, a);
		assertEquals('done', b);
		assertTrue(c instanceof Date);
	}
}