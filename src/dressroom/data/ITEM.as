package dressroom.data
{
	public class ITEM
	{
		public static const SKIN				: String = "skin";
		
		public static const HAIR				: String = "hair";
		public static const OBJECT				: String = "object";
		
		public static const POSE				: String = "pose";
		
		// Order of item layering when occupying the same spot.
		public static const LAYERING			: Array = [ SKIN, HAIR, OBJECT ];
	}
}