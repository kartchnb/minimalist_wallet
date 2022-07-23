include<bezier_lib/bezier_lib.scad>

include<money clip.scad>
include<cover.scad>
include<credit card.scad>

module ElasticBand_Generate(wallet_thickness)
{
    diameter = Elastic_Band_Diameter;

    cover_edge_x_offset = CreditCard_Width/2 + Mate_Spacing;
    groove_y_offset = Cover_Length/2 - Cover_Channel_Inset + Mate_Spacing;
    bottom_z_offset = 0;
    top_z_offset = bottom_z_offset + wallet_thickness;

    clip_edge_x_offset = MoneyClip_Length/2 + Mate_Spacing;
    clip_top_y_offset = MoneyClip_Width/2 - Mate_Spacing;
    clip_inside_z_offset = -MoneyClip_Thickness/2 + Mate_Spacing + Cover_Thickness;

    points =
    [
        [cover_edge_x_offset + diameter/2, groove_y_offset, bottom_z_offset - diameter/2],
        [clip_edge_x_offset + diameter/2, clip_top_y_offset - diameter/2, clip_inside_z_offset],
        [-clip_edge_x_offset + diameter/2, clip_top_y_offset - diameter/2, clip_inside_z_offset],
        [-cover_edge_x_offset - diameter/2, groove_y_offset, bottom_z_offset - diameter/2],
        [-cover_edge_x_offset - diameter/2, groove_y_offset, top_z_offset + diameter/2],
        [cover_edge_x_offset + diameter/2, groove_y_offset, top_z_offset + diameter/2],
        [cover_edge_x_offset + diameter/2, groove_y_offset, bottom_z_offset - diameter/2],
    ];

    for (y_mirror = [0, 1])
    mirror([0, y_mirror, 0])
        BezierLib_DrawPolyLine3D(points, diameter/2);
}