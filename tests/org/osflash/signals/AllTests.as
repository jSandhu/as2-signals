import asunit.framework.TestSuite;
import org.osflash.signals.AmbiguousRelationshipTest;
import org.osflash.signals.SignalScopeTest;
import org.osflash.signals.SignalSplitInterfacesTest;
import org.osflash.signals.SignalTest;
import org.osflash.signals.SignalNoArgsTest;
import org.osflash.signals.SignalDispatchExtraArgsTest;
import org.osflash.signals.SignalDispatchNonEventTest;

class org.osflash.signals.AllTests extends TestSuite
{
	public function AllTests()
	{
		addTest(new SignalTest());
		addTest(new SignalScopeTest());
		addTest(new AmbiguousRelationshipTest());
		addTest(new SignalNoArgsTest());
		addTest(new SignalDispatchExtraArgsTest());
		addTest(new SignalDispatchNonEventTest());	
		addTest(new SignalSplitInterfacesTest());
	}
}
