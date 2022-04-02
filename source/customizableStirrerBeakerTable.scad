// parameters

table_diameter = 150;
table_thickness = 3;
table_border = 30;

bore_diameter = 8;
bore_dist = 2;

leg_height = 20;
leg_diameter = 10;
leg_cnt = 8; //number of legs
leg_inset = 5; //inset from outer table diameter
leg_weight_bore_dia = 5.8; //for use of a screw to lower center of greavity 

rotation_angle_legs = 360/leg_cnt;

this_pattern_space = 15;
this_pattern_dia = 15;
this_pattern_res = 6;
this_pattern_num = table_diameter/this_pattern_dia+3;

//main
difference(){
    union(){
        plate();
        legs();
    }
    intersection(){
        linear_extrude(table_thickness+1, center = true){
            circle(d = table_diameter-table_border);
            }
        translate([-table_diameter/2,-table_diameter/2,0]) //center the pattern
            linear_extrude(table_thickness+1, center = true){
                hole_pattern(this_pattern_num, this_pattern_num, this_pattern_space, sqrt(3)/2*this_pattern_space, this_pattern_dia, this_pattern_res);
        }
    }
}

module plate(){
    linear_extrude(table_thickness, center = true, convexity = 10, $fn=50)
        circle(d = table_diameter);
}

module legs(){
    for (i = [0:leg_cnt]) {
        
        linear_extrude(leg_height, center = false, convexity = 10, $fn=50)
            rotate(a=[0,0,i*rotation_angle_legs])
                translate([table_diameter/2-leg_inset-leg_diameter/2,0,0])
                    difference(){
                        circle(d = leg_diameter);
                        circle(d = leg_weight_bore_dia);
                    }
    }
}

module hole_pattern(num_x = 2, num_y = 2, spacing_x = 4, spacing_y = 4, pattern_dia = 2, pattern_res = 6){
    
    //spacing_y = sqrt(3)/2*spacing_x
    
    for(rowA = [0:2:num_y-1]){
                    for(i=[0:num_x-1]){
                        translate([i*spacing_x,rowA*spacing_y,0])
                            rotate([0,0,180/pattern_res])
                                circle(d = pattern_dia,$fn=pattern_res);
                    }
    }
                for(rowB = [1:2:num_y-1]){
                    for(i=[0:num_x-1]){
                        translate([spacing_x*(i+0.5),rowB*spacing_y,0])
                            rotate([0,0,180/pattern_res])
                                circle(d = pattern_dia,$fn=pattern_res);
                    }
                }
}