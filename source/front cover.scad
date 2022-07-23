include<credit card.scad>
include<cover.scad>



module FrontCover_Generate()
{
    module Generate_InscriptionCutout_Text()
    {
        translate([0, 0, Cover_Thickness - inscription_depth + Iota])
        linear_extrude(inscription_depth)
        resize(inscription_resize, auto=true)
            text(Front_Cover_Inscription_Text, Front_Cover_Inscription_Font, valign="center", halign="center");
    }



    module Generate_InscriptionCutout_SVG()
    {
        translate([0, 0, Cover_Thickness - inscription_depth + Iota])
        linear_extrude(inscription_depth)
        resize(inscription_resize, auto=true)
            import(Front_Cover_Inscription_File);
    }



    inscription_max_width = CreditCard_Width - Cover_Thickness*2;
    
    inscription_max_length = Cover_Length - Cover_Channel_Inset - Cover_Thickness*2;
    
    inscription_resize = 
        [inscription_max_width * Front_Cover_Inscription_Width_Factor/100, inscription_max_length * Front_Cover_Inscription_Length_Factor/100];
    
    inscription_depth = Front_Cover_Inscription_Full_Thickness 
        ? Cover_Thickness + Iota*2
        : Cover_Thickness/2 + Iota;



    difference()
    {
        Cover_Generate();
        if (Front_Cover_Inscription_File != "")
            Generate_InscriptionCutout_SVG();
        if (Front_Cover_Inscription_Text != "")
            Generate_InscriptionCutout_Text();
    }
}