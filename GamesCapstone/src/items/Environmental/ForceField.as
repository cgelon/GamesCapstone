package items.Environmental
{
	import items.Environmental.Background.Circuit.Reactor;

	/**
	 * @author Lydia Duncan
	 */
	public class ForceField extends Reactor 
	{		
		/** Takes the starting X and Y coordinates, the height and width of the field in tile squares, and
		 * an array indicating which sides are present in the order: top, right, bottom, left
		 * 
		 * Refuses to create anything if either the height or the width is 0
		 * 
		 * If the width is 1, draws either the right side or the left side, with right having precedence
		 * if both are specified
		 * 
		 * If the height is 1, draws either the top or the bottom side, with the top having precedence
		 * if both are specified
		 * 
		 * Corner precedence order is top right, bottom right, top left, bottom left
		 * 
		 * Corners take precedence over more normal end pieces
		 */
		function ForceField(Sides: Array, X: Number, Y:Number, Height: Number, 
							Width: Number) : void
		{
			if (Height != 0 && Width != 0)
			{
				var i: int;
				var j: int;
				
				// Draw the horizontal edges of the forcefield (if any)
				for (i = 2; i < Width - 2; i++)
				{
					if (Sides[0])
					{
						(add(new ForceFieldUnit(X + i * 16, Y)) as ForceFieldUnit).midHoriz();
					}
					if (Sides[2] && (!Sides[0] || Height > 1))
					{
						// If bottom should be drawn and our height is greater than 1 or our
						// height is 1 but top was not drawn, then draw the bottom
						(add(new ForceFieldUnit(X + i * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).midHoriz();
					}
				}
				
				// Draw the vertical edges of the forcefield (if any)
				for (j = 2; j < Height - 2; j++)
				{ 
					if (Sides[1])
					{
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + j * 16)) as ForceFieldUnit).midVert();
					}
					// If the left side should be drawn and our width is greater than 1 or our
					// width is 1 but the right side was not drawn, then draw the left side
					if (Sides[3] && (!Sides[1] || Width > 1))
					{
						(add(new ForceFieldUnit(X, Y + j * 16)) as ForceFieldUnit).midVert();
					}					
				}
				
				
				// Corner cases, ha ha
				// top right
				if (Sides[0] && Sides[1]) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).upperRight();
					
					(add(new ForceFieldUnit(X + (Width - 2) * 16, Y)) as ForceFieldUnit).rightHoriz();						
					(add(new ForceFieldUnit(X + (Width - 2) * 16, Y)) as ForceFieldUnit).right();
					
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + 16)) as ForceFieldUnit).upperVert();
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + 16)) as ForceFieldUnit).top();
				} else if (Sides[0] && (Width > 1 || ! Sides[3])) {
					// top left corner takes precedence over rightHoriz
					(add(new ForceFieldUnit(X + (Width - 2) * 16, Y)) as ForceFieldUnit).midHoriz();
					
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).rightHoriz();
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).right();
				} else if (Sides[1] && (Height > 1 || !Sides[2])) {
					// bottom right corner takes precedence over upperVert
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + 16)) as ForceFieldUnit).midVert();
					
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).upperVert();
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).top();
				}
				
				// bottom right
				if (Height > 1 || !Sides[0]) {
					if (Sides[1] && Sides[2]) {
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerRight();
						
						(add(new ForceFieldUnit(X + (Width - 2) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).rightHoriz();
						(add(new ForceFieldUnit(X + (Width - 2) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).right();
						
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 2) * 16)) as ForceFieldUnit).lowerVert();
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 2) * 16)) as ForceFieldUnit).bottom();
					} else if (Sides[1] && Height > 1) {
						// upperVert takes precedence over lowerVert when height = 1						
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 2) * 16)) as ForceFieldUnit).midVert();
						
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert2();
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - .5) * 16)) as ForceFieldUnit).bottom();
					} else if (Sides[2] && (Width > 1 || !Sides[3])) {
						// bottom left corner takes precedence over rightHoriz
						(add(new ForceFieldUnit(X + (Width - 2) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).midHoriz();
						
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).rightHoriz();
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).right();
					}
				}
				
				// top left
				if (Width > 1 || !Sides[1]) {
					if (Sides[0] && Sides[3]) {
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperLeft();
						
						(add(new ForceFieldUnit(X + 16, Y)) as ForceFieldUnit).leftHoriz();
						(add(new ForceFieldUnit(X + 16, Y)) as ForceFieldUnit).left();
						
						(add(new ForceFieldUnit(X, Y + 16)) as ForceFieldUnit).upperVert();
						(add(new ForceFieldUnit(X, Y + 16)) as ForceFieldUnit).top();
					} else if (Sides[0] && Width > 1) {
						// rightHoriz takes precedence over leftHoriz when width = 1
						(add(new ForceFieldUnit(X + 16, Y)) as ForceFieldUnit).midHoriz();
						
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).leftHoriz();
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).left();
					} else if (Sides[3] && (Height > 1 || !Sides[2])) {
						// bottom left corner takes precedence over upperVert
						(add(new ForceFieldUnit(X, Y + 16)) as ForceFieldUnit).midVert();
						
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperVert();
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).top();
					}
				}
				
				// bottom left
				if ((Width > 1 || !Sides[1]) && (Height > 1 || !Sides[0]) ) {
					if (Sides[2] && Sides[3]) {
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerLeft();
						
						(add(new ForceFieldUnit(X + 16, Y + (Height - 1) * 16)) as ForceFieldUnit).leftHoriz();
						(add(new ForceFieldUnit(X + 16, Y + (Height - 1) * 16)) as ForceFieldUnit).left();
						
						(add(new ForceFieldUnit(X, Y + (Height - 2) * 16)) as ForceFieldUnit).lowerVert();
						(add(new ForceFieldUnit(X, Y + (Height - 2) * 16)) as ForceFieldUnit).bottom();
					} else if (Sides[2] && Width > 1) {
						// rightHoriz takes precedence over leftHoriz when width = 1
						(add(new ForceFieldUnit(X + 16, Y + (Height - 1) * 16)) as ForceFieldUnit).midHoriz();
						
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).leftHoriz();
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).left();
					} else if (Sides[3] && Height > 1) {
						// upperVert takes precedence over lowerVert when height = 1
						(add(new ForceFieldUnit(X, Y + (Height - 2) * 16)) as ForceFieldUnit).midVert();
						
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert2();
						(add(new ForceFieldUnit(X, Y + (Height - .5) * 16)) as ForceFieldUnit).bottom();
					}
				}
			}
		}
		
		override public function disable():void 
		{
			super.disable();
			for (var i : int = 0; i < length; i++) 
			{
				(members[i] as ForceFieldUnit).turnOff();
			}
		}
	}
}