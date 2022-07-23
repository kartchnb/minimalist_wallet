include<cover.scad>
include<money clip.scad>



module RearCover_Generate()
{
    module Generate_ClipCutout()
    {
        cutout_width = MoneyClip_Length + Slide_Spacing*2;
        cutout_length = MoneyClip_Width + Slide_Spacing*2;
        cutout_depth = Cover_Thickness + Iota*2;

        x_offset = -cutout_width/2;
        y_offset = -cutout_length/2;
        z_offset = -Iota;

        translate([x_offset, y_offset, z_offset])
            cube([cutout_width, cutout_length, cutout_depth]);
    }



    difference()
    {
        Cover_Generate();
        Generate_ClipCutout();
    }
}