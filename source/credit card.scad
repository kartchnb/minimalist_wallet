// The width of a standard credit card
CreditCard_Width = 85.6;

// The length of a standard credit card
CreditCard_Length = 53.98;

CreditCard_Thickness = 1.588;

CreditCard_Corner_Radius = 3.18;



module CreditCard_GenerateOutline()
{
    corner_radius = CreditCard_Corner_Radius;
    x_delta = CreditCard_Width/2 - corner_radius;
    y_delta = CreditCard_Length/2 - corner_radius;

    hull()
    for (x_offset = [-x_delta, x_delta])
    for (y_offset = [-y_delta, y_delta])
    translate([x_offset, y_offset])
        circle(r=corner_radius);
}



module CreditCard_Generate()
{
    thickness = CreditCard_Thickness;

    linear_extrude(thickness)
    CreditCard_GenerateOutline;
}