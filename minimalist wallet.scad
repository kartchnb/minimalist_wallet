// OpenSCAD Template v1.5

/* [Basic Parameters] */
// The thickness of the covers
Cover_Thickness = 1.751;

// The depth of the pocket insert
Pocket_Insert_Inside_Depth  = 3.001;

// The rough diameter of the elastic bands used to join the two covers.
Elastic_Band_Diameter = 3.001;



/* [Inscription Parameters] */
// The font to use for the front cover inscription
Front_Cover_Inscription_Font = "FreeSans:style=Bold";

// The text to inscribe on the front cover (leave blank for none)
Front_Cover_Inscription_Text = "";

// The name of an SVG file to use to inscribe the front cover (leave blank for none)
Front_Cover_Inscription_File = "";

// This option cuts the inscription completely through the cover (otherwise, it just cuts halfway)
Front_Cover_Inscription_Full_Thickness = false;

// This setting tweaks the width of the inscription
Front_Cover_Inscription_Width_Factor = 0; // [0: 10: 200]

// This setting tweaks the height of the inscription
Front_Cover_Inscription_Length_Factor = 60; // [0: 10: 200]



/* [Model Generation Parameters] */
// The model to generate
Model_To_Generate = "all"; // ["all", "front cover", "rear cover", "pocket insert", "money clip"]

// Generate reference models for external hardware?
Generate_External_Reference_Hardware = true;



/* [Advanced Cover Parameters] */
// The amount to inset the elastic band channels as a percentage of the cover's length
Band_Channel_Inset_Factor = 0.251;

// The width of the access cutouts as a percentage of the cover's width
Access_Width_Factor = 0.501;

// The amount the access cutouts taper in as a percentage of the whole
Access_Taper_Factor = 0.501;

// The amount the wing cutouts taper in as a percentage of the whole
Wing_Taper_Factor = 0.501;



/* [Advanced Money Clip Parameters] */
// The length of the money clip
MoneyClip_Length = 10.001;

// The width of the clip as a percentage of the wallet length
MoneyClip_Width_Factor = 0.501;



/* [Advanced Pocket Insert Parameters] */
// The thickness of the walls in the pocket insert
Pocket_Insert_Wall_Thickness = 1.001;

// The distance to inset the corners
Pocket_Insert_Corner_Inset = 10.001;



/* [Misc. Advanced Parameters] */
// The amount of space to allow between parts intended to mate together
Mate_Spacing = 0.101;

// The amount of space to allow between parts intended to slide across or past each other
Slide_Spacing = 0.201;

// The value to use for rendering the model preview (lower is faster)
Preview_Quality_Value = 16;

// The value to use for rendering the final model (higher is more detailed)
Final_Quality_Value = 64;

// A small value used to make difference() operations look better in preview mode
Iota = 0.001;



/* [Calculated Parameters] */
// Determine the render quality
$fn = $preview ? Preview_Quality_Value : Final_Quality_Value;



/* [External Files] */
include<source/cover.scad>
include<source/credit card.scad>
include<source/elastic band.scad>
include<source/front cover.scad>
include<source/money clip.scad>
include<source/pocket insert.scad>
include<source/rear cover.scad>



module Generate()
{
    rear_cover_z_offset = 0;
    pocket_z_offset = Model_To_Generate == "all" 
        ? rear_cover_z_offset + Cover_Thickness + Mate_Spacing + (Generate_External_Reference_Hardware ? CreditCard_Thickness + Mate_Spacing : 0)
        : 0;
    front_cover_z_offset = Model_To_Generate == "all"
        ? pocket_z_offset + PocketInsert_Thickness + Mate_Spacing + (Generate_External_Reference_Hardware ? CreditCard_Thickness + Mate_Spacing : 0)
        : 0;
    money_clip_z_offset = Model_To_Generate == "all"
        ? -MoneyClip_Thickness - Mate_Spacing + Cover_Thickness
        : 0;
    money_clip_y_rotation = Model_To_Generate == "all"
        ? 0
        : 90;

    if (Model_To_Generate == "all" || Model_To_Generate == "front cover")
    {
        translate([0, 0, front_cover_z_offset])
        {
            color("lightgray")
                FrontCover_Generate();
        }
    }

    if (Model_To_Generate == "all" || Model_To_Generate == "rear cover")
    {
        translate([0, 0, rear_cover_z_offset])
        {
            color("darkgray")
                RearCover_Generate();

            if (Generate_External_Reference_Hardware)
                translate([0, 0, Cover_Thickness])
                    %CreditCard_Generate();
        }
    }

    if (Model_To_Generate == "all" || Model_To_Generate == "pocket insert")
    {
        translate([0, 0, pocket_z_offset])
        {
            color("DodgerBlue")
                PocketInsert_Generate();

            if (Generate_External_Reference_Hardware)
                translate([0, 0, PocketInsert_Thickness])
                    %CreditCard_Generate();
        }
    }
    
    if (Model_To_Generate == "all" || Model_To_Generate == "money clip")
    {
        translate([0, 0, money_clip_z_offset])
        rotate([0, money_clip_y_rotation, 0])
        {
            color("Green")
                MoneyClip_Generate();
        }
    }

    if (Model_To_Generate == "all" && Generate_External_Reference_Hardware)
    {
        wallet_thickness = front_cover_z_offset + Cover_Thickness - rear_cover_z_offset;
        %ElasticBand_Generate(wallet_thickness);
    }
}



// Generate the model
Generate();
