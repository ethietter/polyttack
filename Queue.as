package 
{
	
	/**
	 * ...
	 * @author Edward Hietter
	 */
	public class Queue 
	{
		
		private var data:Array;
		public function Queue(...args) {
			data = args;
		}
		
		public function addItem(item:*) {
			data.unshift(item);
		}
		
		public function removeItem() {
			return data.pop();
		}
	}
	
}