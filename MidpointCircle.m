% Draw a circle in a matrix using the integer midpoint circle algorithm
% Does not miss or repeat pixels
% Created by : Peter Bone
% Created : 19th March 2007
function i = MidpointCircle(i, radius, xc, yc, value)

[r c] = size(i);
xc = int16(xc);
yc = int16(yc);

x = int16(0);
y = int16(radius);
d = int16(1 - radius);

if (yc+y<=c && yc-y>=1 && xc+y<=r && xc-y>=1)

i(xc, min(c,yc+y)) = value;
i(xc, max(yc-y,1)) = value;
i(min(r,xc+y), yc) = value;
i(max(1,xc-y), yc) = value;

while ( x < y - 1 )
    x = x + 1;
    if ( d < 0 ) 
        d = d + x + x + 1;
    else 
        y = y - 1;
        a = x - y + 1;
        d = d + a + a;
    end
    i( min(x+xc,r),  min(c,y+yc)) = value;
    i( min(y+xc,r),  min(c,x+yc)) = value;
    i( min(y+xc,r), max(1,-x+yc)) = value;
    i( min(x+xc,r), max(1,-y+yc)) = value;
    i(max(1,-x+xc), max(1,-y+yc)) = value;
    i(max(1,-y+xc), max(1,-x+yc)) = value;
    i(max(1,-y+xc),  min(x+yc,c)) = value;
    i(max(1,-x+xc),  min(c,y+yc)) = value;
end

end