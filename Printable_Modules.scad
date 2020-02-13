
include <Variables.scad>

Rack();
union() {
    *Rack_Left([0, housingL/2 + 15, 0]);
    *Rack_Right([0, -housingL/2 - 15, 0]);
}
!union() {
    Ring_Lock_Top([16, 0, 0]);
    Ring_Lock_Bot([-16, 0, 0]);
}
//Ring_Lock_Top([0, 0, 80]);
//Ring_Lock_Bot([0, -containerW/4, 5]);

module Rack_Shelf(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    solid_block([rackW, rackL, rackWallT]);
    for (i = [-1 : 2 : 1]) translate([i*(rackW-rackWallT)/2, 0]) {
        solid_block([rackWallT, rackL, rackWallH]);
    }
    
    
    }}
}

module Rack(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    solid_block([rackW, housingL, rackWallT]);
    for (i = [-1 : 2 : 1]) translate([i*(rackW-rackWallT)/2, 0]) {
        difference() {
            solid_block([rackWallT, housingL, housingH + rackWallT]);
            translate([0, -containerW/4 + outerSidePathOffset, sinkinBotH + sinkinH + rackWallT])
                solid_block([rackWallT, containerW/2, sideHoleH]);
        }
        translate([i*(rackWallT + mountW)/2, -(housingL - mountT)/2, 0]) difference() {
            solid_block([mountW, mountT, housingH + rackWallT]);
            for (j = [0 : 2]) translate([0, 0, 6.25 + j*mountHoleOffset]) rotate([90, 0, 0]) translate([0, 0, -(mountHoleH + 0.02)/2])
                elongated_cylinder([mountHoleW, mountHoleL, mountHoleH + 0.02]);
        }
    }
    difference() {
        for (i = [0 : rackInnerW/8 : rackInnerW - rackInnerW/8]) translate([i - rackInnerW/2 + rackInnerW/16, 0, rackWallT]) {
            container_housing();
        }
        translate([0, 0, housingH + rackWallT - ringLockT]) difference() {
            solid_block([housingW - containerH + 0.001, containerW, ringLockT]);
            solid_block([housingW - containerH - ringLockT, containerW - ringLockT, ringLockT]);
        }
        translate([0, -containerW/4, sinkinBotH + rackWallT]) difference() {
            solid_block([housingW - containerH + 0.001, containerW/2, sinkinH]);
            solid_block([housingW - containerH - ringLockT, containerW/2 - ringLockT, sinkinH]);
        }
    }
    
    
    }}
}

module Rack_Left(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    difference() {
        translate([rackW/4 + mountW/2, 0, 0]) intersection() {
            Rack();
            translate([-150, 0, 0])
                solid_block([300, housingL + 1, rackWallT + housingH + 1]);
        }
        translate([rackW/4 + mountW/2, 0, 0])
            inner_chamfering([0, housingL, 1], 1);
    }
    
    
    }}
}

module Rack_Right(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    difference() {
        translate([-rackW/4 - mountW/2, 0, 0]) intersection() {
            Rack();
            translate([150, 0, 0])
                solid_block([300, housingL + 1, rackWallT + housingH + 1]);
        }
        translate([-rackW/4 - mountW/2, 0, 0])
            inner_chamfering([0, housingL, 1], 1);
    }
    
    
    }}
}

module Ring_Lock_Top(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
        
        
    difference() {
        solid_block([housingW - containerH, 64.6, ringLockT]);
        solid_block([17.23, 55.6, ringLockT]);
    }
        
        
    }}
}

module Ring_Lock_Bot(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
        
        
    difference() {
        solid_block([housingW - containerH, 32.3, sinkinH]);
        solid_block([16.8, 22.9, sinkinH]);
    }
        
        
    }}
}

module container_housing() {
    difference() {
        solid_block([housingW, housingL, housingH]);
        //insides
        translate([0, 0, sinkinBotH])
            container_volume();
        //bottom hole
        solid_block([containerH, sinkinBotL, sinkinBotH]);
        //back hole
        translate([0, containerW/2 + (housingL - containerW)/4, sinkinBotH + sinkinH])
            solid_block([containerH - frameT*2, (housingL - containerW)/2, containerL - sinkinH*2]);
        //side hole
        translate([0, -containerW/4, sinkinBotH + sinkinH])
            solid_block([housingW, containerW/2, sideHoleH]);
        //wire pathways
        for (i = [-1 : 2 : 1]) translate([i*(housingW - sidePathW)/2, 0, sinkinBotH + sinkinH])
            solid_block([sidePathW, containerW + (housingL - containerW), sideHoleH]);
        //occupying indicator hole
        translate([0, -(containerW/2 + (housingL - containerW)/4), (housingH - (containerH - frameT*2))/2])
            solid_block([containerH - frameT*2, (housingL - containerW)/2, containerH - frameT*2]);
    }
}

module container_volume() {
    translate([-containerH/2, 0, containerL/2]) rotate([90, 0, 90])
        solid_block([containerW, containerL, containerH]);
}

module solid_block(dimensions) {
    translate([0, 0, dimensions[2]/2])
        cube(dimensions, true);
}

module solid_block_chamfered(dimensions, chamferWidth = 0) {
    difference() {
        solid_block(dimensions);
        for (i = [0 : 1]) {
            translate([(i%2)*(dimensions[0]-chamferWidth)/2, (1-i%2)*(dimensions[1]-chamferWidth)/2, chamferWidth/2])
            rotate([-135*(1-i%2), 135*(i%2), 0])
                solid_block(
                            [(1-i%2)*dimensions[0] + (i%2)*chamferWidth*2, 
                             (i%2)*dimensions[1] + (1-i%2)*chamferWidth*2, 
                             chamferWidth]);
            translate([-(i%2)*(dimensions[0]-chamferWidth)/2, -(1-i%2)*(dimensions[1]-chamferWidth)/2, chamferWidth/2])
            rotate([135*(1-i%2), -135*(i%2), 0])
                solid_block(
                            [(1-i%2)*dimensions[0] + (i%2)*chamferWidth*2, 
                             (i%2)*dimensions[1] + (1-i%2)*chamferWidth*2, 
                             chamferWidth]);
        }
    }
}

module elongated_cylinder(dimensions) {
    radius = dimensions[1]/2;
    elongation = dimensions[0] - dimensions[2];
    for (i = [-1 : 2 : 1]) translate([i * elongation/2, 0, 0])
        cylinder(dimensions[2], radius, radius, $fn=100);
    solid_block([elongation, dimensions[1], dimensions[2]]);
}

module inner_chamfering(dimensions, chamferWidth = 0) {
    dimensions = [dimensions[0]+chamferWidth*2, dimensions[1]+chamferWidth*2, chamferWidth];
    difference() {
        solid_block(dimensions);
        for (i = [0 : 1]) {
            translate([(i%2)*(dimensions[0]-chamferWidth)/2, (1-i%2)*(dimensions[1]-chamferWidth)/2, chamferWidth/2])
            rotate([-45*(1-i%2), 45*(i%2), 0])
                solid_block(
                            [(1-i%2)*dimensions[0] + (i%2)*chamferWidth*2, 
                             (i%2)*dimensions[1] + (1-i%2)*chamferWidth*2, 
                             chamferWidth]);
            translate([-(i%2)*(dimensions[0]-chamferWidth)/2, -(1-i%2)*(dimensions[1]-chamferWidth)/2, chamferWidth/2])
            rotate([45*(1-i%2), -45*(i%2), 0])
                solid_block(
                            [(1-i%2)*dimensions[0] + (i%2)*chamferWidth*2, 
                             (i%2)*dimensions[1] + (1-i%2)*chamferWidth*2, 
                             chamferWidth]);
        }
    }
}

module _format_(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    
    
    
    }}
}