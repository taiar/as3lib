package as3lib
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.DataEvent;
	import flash.display.Loader;

	public class as3lib_xml extends EventDispatcher
	{
		public var src:XML;
		public var pathS:String;
		private var pathLoader:URLLoader;
		private var reqLoader:URLRequest;
		
		public const COMPLETE:String = "xmlLoadComplete";

		public function as3lib_xml(p:String):void
		{
			this.pathS = p;
			this.reqLoader = new URLRequest(this.pathS);

			this.setPath();
		}

		private function setPath():void
		{
			this.pathLoader = new URLLoader();
			this.pathLoader.load(this.reqLoader);
			this.pathLoader.addEventListener(Event.COMPLETE, this.setOk);
		}

		public function setOk(e:Event):void
		{
			this.src = new XML(this.pathLoader.data);

			this.dispatchEvent(new Event(COMPLETE)); 
		}
	}
}