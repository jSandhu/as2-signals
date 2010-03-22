import asunit.textui.TestRunner;
import org.osflash.signals.AllTests;

class org.osflash.signals.AllTestsRunner extends TestRunner
{
	public function AllTestsRunner() 
	{
		start(AllTests);
	}
	
	public static function main(parentMC:MovieClip):Void
	{
		var runner:TestRunner = new AllTestsRunner(parentMC);
	}	
}