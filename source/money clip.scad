include<cover.scad>



MoneyClip_Thickness = Pocket_Insert_Wall_Thickness + Slide_Spacing + Elastic_Band_Diameter + Slide_Spacing + Pocket_Insert_Wall_Thickness;

MoneyClip_Width = (Cover_Length * Groove_Inset_Factor*2 - Pocket_Insert_Wall_Thickness*2) * MoneyClip_Width_Factor;



module MoneyClip_Generate()
{
    module Generate_Outline()
    {
        y_offset = MoneyClip_Width()/2  - outer_diameter/2;

        difference()
        {
            hull()
            for (y_mirror = [0, 1])
            mirror([0, y_mirror])
            translate([0, y_offset])
                circle(d=outer_diameter);

            hull()
            for (y_mirror = [0, 1])
            mirror([0, y_mirror])
            translate([0, y_offset])
                circle(d=inner_diameter);

        }
    }



    module Generate_GapCutout()
    {
        y_offset = MoneyClip_Width/2 - outer_diameter;
        x_offset = 0;

        width = MoneyClip_Width; // Overkill
        height = Mate_Spacing;

        translate([x_offset, y_offset])
            square([width, height]);
    }



    outer_diameter = MoneyClip_Thickness();
    inner_diameter = outer_diameter - Pocket_Insert_Wall_Thickness*2;
    length = MoneyClip_Length;

    x_offset = -length/2;
    z_offset = MoneyClip_Thickness/2;

    translate([x_offset, 0, z_offset])
    rotate([0, 90, 0])
    linear_extrude(length)
    difference()
    {
        Generate_Outline();
        Generate_GapCutout();
    }
}