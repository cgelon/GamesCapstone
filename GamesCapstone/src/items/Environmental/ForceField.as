package items.Environmental
{
	import managers.ObjectManager;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class ForceField extends EnvironmentalGroup 
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
		function ForceField(Sides: Array, X: Number = 0, Y:Number = 0, Height: Number = 0, 
							Width: Number = 0) : void
		{
			if (Height != 0 && Width != 0)
			{
				var i: int;
				var j: int;
				
				// Draw the horizontal edges of the forcefield (if any)
				for (i = 1; i < Width - 1; i++)
				{
					if (Sides[0])
					{
						(add(new ForceFieldUnit(X + i * 16, Y)) as ForceFieldUnit).midHoriz();
					}
					// If bottom should be drawn and our height is greater than 1 or our
					// height is 1 but top was not drawn, then draw the bottom
					if (Sides[2] && (!Sides[0] || Height > 1))
					{
						(add(new ForceFieldUnit(X + i * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).midHoriz();
					}
				}
				
				// Draw the vertical edges of the forcefield (if any)
				for (j = 1; j < Height - 1; j++)
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
				} else if (Sides[0] && (Width > 1 || ! Sides[3])) {
					// top left corner takes precedence over rightHoriz
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).rightHoriz();
				} else if (Sides[1] && (Height > 1 || !Sides[2])) {
					// bottom right corner takes precedence over upperVert
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).upperVert();
				}
				
				// bottom right
				if (Height > 1 || !Sides[0]) {
					if (Sides[1] && Sides[2]) {
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerRight();
					} else if (Sides[1] && Height > 1) {
						// upperVert takes precedence over lowerVert when height = 1
						(add(new ForceFieldUnit(X + (Width -1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert();
					} else if (Sides[2] && (Width > 1 || !Sides[3])) {
						// bottom left corner takes precedence over rightHoriz
						(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).rightHoriz();
					}
				}
				
				// top left
				if (Width > 1 || !Sides[1]) {
					if (Sides[0] && Sides[3]) {
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperLeft();
					} else if (Sides[0] && Width > 1) {
						// rightHoriz takes precedence over leftHoriz when width = 1
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).leftHoriz();
					} else if (Sides[3] && (Height > 1 || !Sides[2])) {
						// bottom left corner takes precedence over upperVert
						(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperVert();
					}
				}
				
				// bottom left
				if ((Width > 1 || !Sides[1]) && (Height > 1 || !Sides[0]) ) {
					if (Sides[2] && Sides[3]) {
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerLeft();
					} else if (Sides[2] && Width > 1) {
						// rightHoriz takes precedence over leftHoriz when width = 1
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).leftHoriz();
					} else if (Sides[3] && Height > 1) {
						// upperVert takes precedence over lowerVert when height = 1
						(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert();
					}
				}
			}
			
			/*
			// "Corner case", ha ha
			if (Sides[0] && Sides[3]) {
				(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperLeft();
			} else if (Sides[0]) {
				(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).leftHoriz();
			} else if (Sides[3]) {
				(add(new ForceFieldUnit(X, Y)) as ForceFieldUnit).upperVert();
			}
			
			// Draws the top 
			if (Sides[0]) {
				for (i = 1; i < Width - 1; i++) {
					(add(new ForceFieldUnit(X + i * 16, Y)) as ForceFieldUnit).midHoriz();
				}				
				// "Corner case", ha ha
				if (Sides[1]) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).upperRight();
				} else {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).rightHoriz();
				}
			}
			// Draws the right side
			if (Sides[1]) {
				// "Corner case", ha ha
				if (!Sides[0]) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y)) as ForceFieldUnit).upperVert();
				}
				for (j = 1; j < Height - 1; j++) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + j * 16)) as ForceFieldUnit).midVert();
				}
				// "Corner case", ha ha
				if (Sides[2]) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerRight();
				} else {
					(add(new ForceFieldUnit(X + (Width -1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert();
				}
			}
			// Draws the bottom
			if (Sides[2]) {
				// "Corner case", ha ha
				if (!Sides[1]) {
					(add(new ForceFieldUnit(X + (Width - 1) * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).rightHoriz();
				}
				for (i = Width - 2; i > 0; i--) {
					(add(new ForceFieldUnit(X + i * 16, Y + (Height - 1) * 16)) as ForceFieldUnit).midHoriz();
				}				
				// "Corner case", ha ha
				if (Sides[3]) {
					(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerLeft();
				} else {
					(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).leftHoriz();
				}
			}
			// Draws the left side
			if (Sides[3]) {
				// "Corner case", ha ha
				if (!Sides[2]) {
					(add(new ForceFieldUnit(X, Y + (Height - 1) * 16)) as ForceFieldUnit).lowerVert();
				}
				for (j = Height - 2; j > 0; j--) {
					(add(new ForceFieldUnit(X, Y + j * 16)) as ForceFieldUnit).midVert();
				}
			}
			*/
		}		
	}
}