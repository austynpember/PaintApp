package events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author dave.rodriguez
	 */
	public class InfoEvent extends Event
	{
		private var _data:*;
		
		
		public function InfoEvent(type:String, data:*, bubbles:Boolean = true, cancelable:Boolean = true ) 
		{
			_data = data;
			super (type, bubbles, cancelable);
		}
		
		public function get data():* { return _data; }
		
		public override function clone():Event {
			return new InfoEvent(this.type, this.data, this.bubbles, this.cancelable);
		}
		
	}

}