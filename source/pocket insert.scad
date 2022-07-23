include<credit card.scad>



PocketInsert_Thickness = Pocket_Insert_Wall_Thickness + Pocket_Insert_Inside_Depth;



module PocketInsert_Generate()
{
    module Generate_BasicBody()
    {
        linear_extrude(PocketInsert_Thickness)
            CreditCard_GenerateOutline();
    }



    module Generate_Opening()
    {
        width = CreditCard_Width - Pocket_Insert_Wall_Thickness*2;
        height = CreditCard_Length - Pocket_Insert_Wall_Thickness*2;

        translate([0, 0, Pocket_Insert_Wall_Thickness])
        linear_extrude(PocketInsert_Thickness)
        resize([width, height])
            CreditCard_GenerateOutline();
    }



    module Generate_Corners()
    {
        width = Pocket_Insert_Corner_Inset*2;
        height = CreditCard_Width*2;
        depth = Pocket_Insert_Wall_Thickness;

        x_offset = CreditCard_Width/2;
        y_offset = CreditCard_Length/2;
        z_offset = Pocket_Insert_Inside_Depth;

        translate([0, 0, z_offset])
        linear_extrude(depth)
        intersection()
        {
            for (x_mirror = [0, 1])
            for (y_mirror = [0, 1])
            mirror([x_mirror, y_mirror])
            translate([x_offset, y_offset])
            rotate([0, 0, 45])
            translate([-width/2, -height/2])
                square([width, height]);

            CreditCard_GenerateOutline();
        }
    }


    
    difference()
    {
        Generate_BasicBody();
        Generate_Opening();
    }

    Generate_Corners();
}