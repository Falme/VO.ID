local class = require 'middleclass'

MateFunc = class('MateFunc')

function MateFunc:initialize()


end

function MateFunc:Linear(t, b, c, d)
	return c*t/d + b;
end

function MateFunc:QuadOut(t, b, c, d)
	t = t/d;
	return -c * t*(t-2) + b;
end

function MateFunc:PtToPx(points)
	return points * 96 / 72
end

function MateFunc:PxToPt(pixels)
	return pixels * 72 / 96
end

function MateFunc:GetDistance(Val1, Val2)
	return math.sqrt( ( Val1.X - Val2.X ) * (Val1.X - Val2.X ) + (Val1.Y - Val2.Y ) * (Val1.Y - Val2.Y ))
end

function MateFunc:Distance(obj1, obj2)
  return math.sqrt((obj2.X - obj1.X) ^ 2 + (obj2.Y - obj1.Y) ^ 2)
end

function MateFunc:DistanceCollision(circleA, circleB)
    local dist = math.sqrt((circleA.X - circleB.X)^2 + (circleA.X - circleB.X)^2)
    return dist <= circleA.Size + circleB.Size
end

function MateFunc:GetAngleTwoPoints(Obj1, Obj2)

	return math.deg(math.atan2( Obj2.Y-Obj1.Y,Obj2.X-Obj1.X ))
	--return math.atan2( Obj2.Y-Obj1.Y,Obj2.X-Obj1.X )

end