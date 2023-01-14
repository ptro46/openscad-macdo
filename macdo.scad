$fn=100;

burger_box_base_x = 100 ;
burger_box_base_y = 100 ;
burger_box_base_z = 4 ;
burger_box_base_r = 25 ;

burger_box_h = 8*burger_box_base_x/10 ;

burger_box_top_scale_factor = 0.8 ;

burger_box_base_border_thikness = 5 ;
margin = 2 ;

/* [Parameters] */
do_burger_box_full = true ;
do_fries_box_full = true ;
do_only_fries_box = false ;
do_only_burger_box_without_base  = false ;
do_only_burger_box_base = false ;
do_only_burger_box_without_base_multimaterial = false ;
do_only_smile_multimaterial = false ;
do_only_m_macdo_multimaterial = false ;

do_test = false ;

module round_cube(x,y,z,r) {
    cyl_r = r ;
    t_x = x/2-cyl_r ;
    t_y = y/2-cyl_r ;        
    hull() {
        translate([t_x,t_y,0]) {
            cylinder(h=z,r=cyl_r,center=true);
        }
        translate([-t_x,t_y,0]) {
            cylinder(h=z,r=cyl_r,center=true);
        }
        translate([t_x,-t_y,0]) {
            cylinder(h=z,r=cyl_r,center=true);
        }
        translate([-t_x,-t_y,0]) {
            cylinder(h=z,r=cyl_r,center=true);
        }
    }
}

module burger_box_base() {
    union() {
        round_cube(burger_box_base_x,
                    burger_box_base_y,
                    burger_box_base_z,
                    burger_box_base_r);

        translate([0,0,burger_box_base_border_thikness]) {
            difference() {
                round_cube(burger_box_base_x - burger_box_base_border_thikness,
                            burger_box_base_y - burger_box_base_border_thikness ,
                            burger_box_base_z + burger_box_base_border_thikness ,
                            burger_box_base_r);

                round_cube(burger_box_base_x - 2 * burger_box_base_border_thikness ,
                            burger_box_base_y - 2 * burger_box_base_border_thikness ,
                            burger_box_base_z + 2 * burger_box_base_border_thikness ,
                            burger_box_base_r);
            }
        }
    }
}

module burger_box() {
    difference() {
        hull() {
            round_cube(burger_box_base_x,
                        burger_box_base_y,
                        0.1,
                        burger_box_base_r);
            translate([0,0,burger_box_h]) {
                scale([burger_box_top_scale_factor,burger_box_top_scale_factor,1]) {
                    round_cube(burger_box_base_x,
                                burger_box_base_y,
                                burger_box_base_z,
                                burger_box_base_r);                    
                }        
            }
        }
        hull() {
            round_cube(burger_box_base_x - burger_box_base_border_thikness+margin,
                        burger_box_base_y - burger_box_base_border_thikness+margin ,
                        burger_box_base_z + burger_box_base_border_thikness ,
                        burger_box_base_r);
            translate([0,0,burger_box_h-burger_box_base_border_thikness]) {
                scale([burger_box_top_scale_factor,burger_box_top_scale_factor,1]) {
                    round_cube(burger_box_base_x - burger_box_base_border_thikness+margin,
                                burger_box_base_y - burger_box_base_border_thikness+margin ,
                                burger_box_base_z,
                                burger_box_base_r);
                }        
            }
        }
    }
    translate([0,-burger_box_base_y/2-2,4]) {
        rotate([90,0,0])
        round_cube(30,8,5,2);
    }
}

module m_macdo() {
    render() {
        difference() {
            translate([0,0,burger_box_h]) {
                rotate([90,0,0]) {
                    scale([0.6,0.6,2]) {
                        import("m-macdo.stl");
                    }
                }
            }    
            base_diff_h = 10*burger_box_base_z;
            translate([0,0,burger_box_h+burger_box_base_z-base_diff_h/2-1]) {
                cube([burger_box_base_x,burger_box_base_y,base_diff_h],center=true);
            }
        }
    }
}

module smile() {
    union() {
        union() {
            difference() {
                difference() {
                    scale([1.17,1,1]) {
                        cylinder(h=10,r=93,center=true);
                    }
                    scale([1.22,1,1]) {
                        cylinder(h=12,r=78,center=true);
                    }
                }
                translate([0,105,0]) {
                    cube([400,200,12],center=true);
                }
            }
            translate([105,8,0]) {
                rotate([0,0,-30]) {
                    cube([50,15,10],center=true);
                }
            }
        }
        translate([-105,8,0]) {
            rotate([0,0,30]) {
                cube([50,15,10],center=true);
            }
        }
    }
}

module smile_macdo() {
    translate([0,-35.25,10]) {
        rotate([90,0,0]) {
            translate([0,burger_box_h/2,9]) {
                rotate([-7,0,0]) {
                    scale([0.15,0.15,0.03]) {
                        smile();
                    }
                }
            }
        }
    }
}

module burger_box_full() {
    translate([0,0,-20]) {
        burger_box_base();
    }

    union() {
        difference() {
            color("red") {
                translate([0,0,burger_box_base_z]) {
                    burger_box();
                }
            }
            m_macdo();
        }
        smile_macdo();
    }
    m_macdo();
}

module burger_box_multi_material() {
    difference() {
        difference() {
            color("red") {
                translate([0,0,burger_box_base_z]) {
                    burger_box();
                }
            }
            m_macdo();
        }
        smile_macdo();
    }
}


fries_box_h = burger_box_h ;
fries_box_r = 2*(burger_box_base_x/2)/3 ;

module fries_box() {
    scale([1.3,0.6,1.2]) {
        difference() {
            difference() {
                cylinder(h=fries_box_h, r=fries_box_r,center=true);
                translate([0,0,4]) {
                    cylinder(h=fries_box_h, r=fries_box_r-4,center=true);
                }
            }
            translate([0,-10,0]) {
                translate([0,0,fries_box_h/2]) {
                    rotate([30,0,0])
                    cube([3*fries_box_r,3*fries_box_r,50],center=true);
                }
            }
        }
    }
}

module burger_box_full_without_base() {
    union() {
        difference() {
            color("red") {
                translate([0,0,burger_box_base_z]) {
                    burger_box();
                }
            }
            m_macdo();
        }
        smile_macdo();
    }
    m_macdo();
}

if ( do_burger_box_full ) {
    translate([-burger_box_base_x,0,0]) {
        burger_box_full();
    }
}

if ( do_fries_box_full ) {
    translate([burger_box_base_x,0,fries_box_h/2]) {
        color("red")
            fries_box();
    }
}

if ( do_only_fries_box ) {
    // only fries_box
    fries_box();
}

if ( do_only_burger_box_without_base ) {
    // only burger_box without base
    burger_box_full_without_base();
}

if ( do_only_burger_box_base ) {
    // only burger_box base
    burger_box_base();
}

if ( do_only_burger_box_without_base_multimaterial ) {
    // only burger_box without base for multimaterial
    burger_box_multi_material();
}

if ( do_only_smile_multimaterial ) {
    // only smile for multi material
    smile_macdo();
}

if ( do_only_m_macdo_multimaterial ) {
    // only M Macdo for multi material
    m_macdo();
}

/*
if ( do_test ) {
//    burger_box();
    burger_box_base();
    difference() {
        burger_box();
        translate([0,0,2*burger_box_base_z]) {
            cube([200,200,200],center=false);
        }
    }
}
*/

