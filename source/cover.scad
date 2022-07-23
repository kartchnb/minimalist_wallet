include<credit card.scad>



// Calculate the width of the "wings" on either end of the cover
Cover_Wing_Width = Elastic_Band_Diameter + Slide_Spacing;

// The cover is a little wider than a credit card to accomodate the elastic band
Cover_Width = CreditCard_Width + Cover_Wing_Width*2;

// The cover is the same height as a credit card
Cover_Length = CreditCard_Length;

// The cover has the same corner radius as a credit card
Cover_Corner_Radius = CreditCard_Corner_Radius;

// Determine how far to inset the channels for the elastic bands
Cover_Channel_Inset = Cover_Length * Band_Channel_Inset_Factor;

// Calculate the diameter of the channel for the elastic bands
Cover_Channel_Diameter = Elastic_Band_Diameter + Slide_Spacing*2;



module Cover_Generate()
{
    module Generate_BasicBodyOutline()
    {
        width = Cover_Width;
        height = Cover_Length;
        corner_radius = Cover_Corner_Radius;

        x_delta = width/2 - corner_radius;
        y_delta = height/2 - corner_radius;

        hull()
        for (x_offset = [-x_delta, x_delta])
        for (y_offset = [-y_delta, y_delta])
        translate([x_offset, y_offset])
            circle(r=corner_radius);
    }



    module Generate_ChannelCutoutOutlines()
    {
        groove_inset = Cover_Channel_Inset;

        groove_x_offset = CreditCard_Width/2 + Cover_Channel_Diameter/2;
        groove_y_offset = Cover_Length/2 - groove_inset;
        
        capture_width = Cover_Width; // Overkill
        capture_length = Cover_Channel_Diameter/2;
        
        capture_x_offset = groove_x_offset;
        capture_y_offset = groove_y_offset - capture_length/2;

        translate([0, 0, -Iota])
        for (x_mirror = [0, 1])
        for (y_mirror = [0, 1])
        mirror([0, y_mirror])
        mirror([x_mirror, 0])
        {
            translate([groove_x_offset, groove_y_offset])
                circle(d=Cover_Channel_Diameter);
            translate([capture_x_offset, capture_y_offset])
                square([capture_width, capture_length]);
        }
    }



    module Generate_WingCutoutOutlines()
    {
        cutout_width = Elastic_Band_Diameter + Slide_Spacing;
        cutout_length_1 = Cover_Length * Band_Channel_Inset_Factor*2 - Cover_Channel_Diameter - Cover_Thickness*2;
        cutout_length_2 = cutout_length_1 * Wing_Taper_Factor;

        cutout_x_offset = Cover_Width/2;
        cutout_y_offset = 0;

        cutout_points =
        [
            [0, cutout_length_1/2],
            [-cutout_width, cutout_length_2/2],
            [-cutout_width, -cutout_length_2/2],
            [0, -cutout_length_1/2],
        ];

        for (x_mirror = [0, 1])
        mirror([x_mirror, 0])
        translate([cutout_x_offset, cutout_y_offset])
            polygon(cutout_points);
    }



    module Generate_AccessCutouts()
    {
        cutout_width_1 = Cover_Width * Access_Width_Factor;
        cutout_width_2 = cutout_width_1 * Access_Taper_Factor;
        cutout_length = Cover_Channel_Inset;

        cutout_x_offset = 0;
        cutout_y_offset = Cover_Length/2;

        cutout_points = 
        [
            [-cutout_width_1/2, 0],
            [cutout_width_1/2, 0,],
            [cutout_width_2/2, -cutout_length],
            [-cutout_width_2/2, -cutout_length],
        ];

        for (y_mirror = [0, 1])
        mirror([0, y_mirror])
        translate([cutout_x_offset, cutout_y_offset])
            polygon(cutout_points);
    }



    module Generate_Cover()
    {
        thickness = Cover_Thickness;

        linear_extrude(thickness)
        difference()
        {
            Generate_BasicBodyOutline();
            Generate_ChannelCutoutOutlines();
            Generate_WingCutoutOutlines();
            Generate_AccessCutouts();
        }
    }



    Generate_Cover();
}