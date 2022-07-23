include<cover.scad>



module FrontCover_Generate()
{
    module Generate_InscriptionCutout_Text()
    {
        translate([0, 0, Cover_Thickness - inscription_depth + Iota])
        linear_extrude(inscription_depth)
        resize(inscription_resize, auto=true)
            import(Front_Cover_Inscription_File);
    }



    module Generate_InscriptionCutout_SVG()
    {
        translate([0, 0, Cover_Thickness - inscription_depth + Iota])
        linear_extrude(inscription_depth)
        resize(inscription_resize, auto=true)
            text(Front_Cover_Inscription_Font, Front_Cover_Inscription_Text, valign="center", halign="center");
    }



    inscription_max_width = Cover_Width - Wall_Thickness*2;
    inscription_max_length = Cover_Length * Groove_Inset_Factor*2 - Cover_Thickness*2;
    inscription_resize = Front_Cover_Inscription_Fit_to_Width
        ? [inscription_max_width, 0]
        : [0, inscription_max_length];
    inscription_depth = Front_Cover_Inscription_Full_Thickness 
        ? Cover_Thickness + Iota*2
        : Cover_Thickness + Iota;



    difference()
    {
        Cover_Generate();
        if (Front_Cover_Inscription_File != "")
            Generate_InscriptionCutout_SVG();
        if (Front_Cover_Inscription_Text != "")
            Generate_InscriptionCutout_Text();
    }
}