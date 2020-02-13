include <Pi_Container.scad>

containerH = usbPortH - boardBotSideCompH + usbPortHeightOffset + containerBaseH + boardBotH + boardH + usbPortHeightOffset + containerBaseH + boardBotH + boardH + boardBotSideCompH;

socketW = 29.75;
socketL = 89.7;
socketHF = 4.5;
socketHB = 11.5;
socketLF = 25;
socketLB = 5.3;

socketBaseW = socketW + 30;
socketBaseL = socketL + 30;
socketBaseH = 5;


*#Full_Container([0, 0, containerW/2 + socketBaseH], [0, -90, 0], true);
Socket_Base();
Socket_Top([0, 0, socketBaseH*2 + containerW + 1], [0, 180, 0]);
*hook_block([10, 10, 3], 15);
*#container_volume([0, 0, socketBaseH]);

//print this
!union() {
    Socket_Top([35, 0, 0]);
    Socket_Base([-35, 0, 0]);
}


module Full_Container(shift = [0, 0, 0], rotation = [0, 0, 0], centered = false) {
    render() translate(shift) { rotate(rotation) {


        if (centered) {
            Container_Top([0, 0, containerBaseH + boardBotH + boardH + boardBotSideCompH - containerH/2]);
            Container_Bottom([0, 0, -containerH/2]);
        }
        else {
            Container_Top([0, 0, containerBaseH + boardBotH + boardH + boardBotSideCompH]);
            Container_Bottom();
        }


    }}
}

module container_volume(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    translate([0, -4/2, 0])
        solid_block([socketW, containerL + 4, containerW+1]);
    
    
    }}
}

module Socket_Base(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    solid_block_chamfered([socketBaseW, socketBaseL, socketBaseH], 1);
    translate([0, 0, socketBaseH]) {
        difference() {
            union() {
                translate([0, (socketBaseL - socketLF - (socketBaseL - socketL)/2)/2, 0])
                    solid_block([socketBaseW, socketLF + (socketBaseL - socketL)/2, socketHF]);
                translate([0, (-socketBaseL + socketLB + (socketBaseL - socketL)/2)/2, 0])
                    solid_block([socketBaseW, socketLB + (socketBaseL - socketL)/2, socketHB]);
                // translate([(socketBaseW - (socketBaseW - socketW)/2)/2, 0, 0])
                //     solid_block([(socketBaseW - socketW)/2, socketL, socketHF]);
            }
            solid_block([socketW, socketL, socketHB]);
        }
        for (i = [-1 : 2 : 1]) translate([i*(socketBaseW/2 - (socketBaseW - socketW)/4), -socketBaseL/2 + socketLB + (socketBaseL - socketL)/2 - 5 , socketHB]) rotate([0, 0, -90]) {
            hook_block([10, (socketBaseW - socketW)/2, 5], 5);
        }
        for (i = [-1 : 2 : 1]) translate([i*(socketBaseW/2 - (socketBaseW - socketW)/4), socketBaseL/2 - socketLF - (socketBaseL - socketL)/2 + 16 , socketHF]) rotate([0, 0, 90]) {
            hook_block([32, (socketBaseW - socketW)/2, 5], 5);
        }
    }
    
    
    }}
}

module Socket_Top(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    intersection() {
        union() {
            translate([0, (socketBaseL - socketLF - (socketBaseL - socketL)/2)/2, 0])
                solid_block([socketBaseW, socketLF + (socketBaseL - socketL)/2, socketBaseH]);
            translate([0, (-socketBaseL + socketLB + (socketBaseL - socketL)/2)/2, 0])
                solid_block([socketBaseW, socketLB + (socketBaseL - socketL)/2, socketBaseH]);
            for (i = [-1 : 2 : 1]) translate([i*(socketBaseW - (socketBaseW - socketW)/2)/2, 0, 0])
                solid_block([(socketBaseW - socketW)/2, socketL, socketBaseH]);
        }
        solid_block_chamfered([socketBaseW, socketBaseL, socketBaseH], 1);
    }
    translate([0, 0, socketBaseH]) {
        difference() {
            union() {
                translate([0, (socketBaseL - socketLF - (socketBaseL - socketL)/2)/2, 0])
                    solid_block([socketBaseW, socketLF + (socketBaseL - socketL)/2, containerW - socketHF - 5 + 0.7]);
                translate([0, (-socketBaseL + socketLB + (socketBaseL - socketL)/2)/2, 0])
                    solid_block([socketBaseW, socketLB + (socketBaseL - socketL)/2, containerW - socketHB - 5 + 0.7]);
                for (i = [-1 : 2 : 1]) translate([i*(socketBaseW - (socketBaseW - socketW)/2)/2, 0, 0])
                    solid_block([(socketBaseW - socketW)/2, socketL, containerW - socketHB - 5]);
            }
            container_volume();
            translate([0, socketBaseL/2 - (socketBaseL - containerL)/4, socketHF])
                solid_block([socketW, (socketBaseL - containerL)/2, containerW]);
        }
        for (i = [-1 : 2 : 1]) translate([i*(socketBaseW/2 - (socketBaseW - socketW)/4), -socketBaseL/2 + 9.5/2, containerW - socketHB - 5 + 0.7]) rotate([0, 0, 90]) {
            hook_block([9.5, (socketBaseW - socketW)/2, 5], 5);
        }
        for (i = [-1 : 2 : 1]) translate([i*(socketBaseW/2 - (socketBaseW - socketW)/4), socketBaseL/2 - 7/2 , containerW - socketHF - 5 + 0.7]) rotate([0, 0, -90]) {
            #hook_block([7, (socketBaseW - socketW)/2, 5], 5);
        }
    }
    
    
    }}
}

module hook_block(dimensions, angle = 45) {
    intersection() {
        union() {
            solid_block(dimensions);
            translate([dimensions[0]/2, 0, 0]) rotate([0, angle, 0]) translate([(-dimensions[0]/cos(angle))/2, 0, 0]) {
                solid_block([dimensions[0]/cos(angle), dimensions[1], dimensions[2]/cos(angle)]);
            }
        }
        solid_block([dimensions[0] + dimensions[2]*tan(angle)*2, dimensions[1], dimensions[2]]);
    }
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

module _format_(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    
    
    
    }}
}