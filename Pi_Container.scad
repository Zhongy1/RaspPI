
boardWLIncrease = 0.5;
boardW = 56 + boardWLIncrease;
boardL = 85 + boardWLIncrease;
boardBotH = 3;
boardH = 1.5;
boardBotSideCompH = 3;

containerBaseH = 1.5;
containerWallT = 1.5;
containerExtWT = 4;
containerW = boardW + containerExtWT*2;
containerL = boardL + containerWallT*2;

mUsbH = 2.95; //exact
mUsbL = 9;
mUsbOffset = 10.6; //relative to the bottom edge (rbe)

hdmiH = 5.6; //exact
hdmiL = 16;
hdmiOffset = 31.87 + boardWLIncrease/2; //rbe

ajH = 6; //exact
ajL = 7.4;
ajOffset = 53.71 + boardWLIncrease/2; //rbe

portClearingL = (hdmiOffset - mUsbOffset) + (mUsbL + hdmiL)/2 + 7;

ePortH = 13.6; //exact
ePortW = 16.4;
ePortOffset = 10.4 + boardWLIncrease/2; //relative to the right edge (rre)

sdcPortH = 1.8;
sdcPortW = 15;

usbPortH = 14.32; //exact
usbPortW = 13.7;
usbPortHeightOffset = 1;
usbPortOffset1 = 28.6 + boardWLIncrease/2; //rre
usbPortOffset2 = 46.6 + boardWLIncrease/2; //rre

shaftDiam = 5.4;
shaftInnerDiam = 1.9;
shaftInnerH = containerBaseH + boardBotSideCompH + boardH + 2.5;
shaftFitOnsInDiam = 2.4;
shaftFitOnsInH = shaftInnerH - (containerBaseH + boardBotSideCompH) + 0.2;
shaftFitOnsH = containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortH - boardBotSideCompH + usbPortHeightOffset + boardBotSideCompH;
shaftSideOffset = 3.5 + boardWLIncrease/2;
shaftLowerOffset = 3.5 + boardWLIncrease/2;
shaftUpperOffset = 61.5 + boardWLIncrease/2;

coverOpeningW = 7;
coverOpeningL = shaftUpperOffset - shaftLowerOffset - shaftDiam;

lockOnsFitW = 2.5;
lockOnsFitL = 4.6;
lockOnsFitH = 2.65;
lockOnsW = lockOnsFitW - 0.3;
lockOnsL = lockOnsFitL - 0.3;
lockOnsH = lockOnsFitH - 0.35;
botLockAreaW = lockOnsFitL * 2;
botLockAreaL = containerExtWT;

//Print This
!union() {
    translate([-35, 0])
        Container_Top_Pins_Friendly([0, 0, containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortH - boardBotSideCompH + usbPortHeightOffset], [0, 180, 0]);
    translate([35, 0])
        Container_Bottom([0, 0, 0]);
}

//Container Bottom Piece
*Container_Bottom([0, 0, -50]);

//Container Top Piece
*Container_Top([0, 0, containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortH - boardBotSideCompH + usbPortHeightOffset], [0, 180, 0]);
*%Container_Top([0, 0, -50 + containerBaseH + boardBotH + boardH + boardBotSideCompH]);

Container_Top_Open([0, 0, containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortH - boardBotSideCompH + usbPortHeightOffset], [0, 180, 0]);
*Open_Top_Cover();
*Container_Top_Pins_Friendly([0, 0, containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortH - boardBotSideCompH + usbPortHeightOffset], [0, 180, 0]);




module Container_Top(shift = [0, 0, 0], rotation = [0, 0, 0], chamferred = true) {
    translate(shift) { rotate(rotation) {
    
    
    usbPortRemainingH = usbPortH - boardBotSideCompH + usbPortHeightOffset;
    height = containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortRemainingH;
    difference() {
        //full size
        translate([0, 0, height]) { rotate([0, 180, 0]) {
            if (chamferred == true)
                solid_block_chamfered([containerW, containerL, height], 0.5);
            else
                solid_block([containerW, containerL, height]);
            translate([0, -(boardL+botLockAreaL)/2]) {
                for (i = [-1 : 2 : 1]) {
                    translate([i*boardW/4, 0])
                        solid_block([botLockAreaW, botLockAreaL, height]);
                }
            }
        }}
        
        //inner volume cut out
        solid_block([boardW, boardL, height - containerBaseH]);
        
        //Right hand side components
        translate([(boardW+containerExtWT)/2, -(boardL)/2, -boardBotSideCompH]) {
            additionalSafetyH = 1.2;
            //hdmi
            translate([0, hdmiOffset, 0])
                solid_block([containerExtWT, hdmiL, hdmiH + additionalSafetyH]);
            //aj
            translate([0, ajOffset, 0])
                solid_block([containerExtWT + 0.001, ajL, ajH]);
        }
        
        //wall clearing
        translate([(boardW+containerExtWT+containerWallT)/2, -(boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (hdmiL - mUsbL)/4, -0.0015])
            solid_block([containerExtWT - containerWallT + 0.001, portClearingL, height + 0.003]);
        
        //Top side components
        translate([(boardW)/2, (boardL+containerWallT)/2, -boardBotSideCompH]) {
            additionalSafetyH = 0.3;
            //ePort
            translate([-ePortOffset, 0, 0])
                solid_block([ePortW, containerWallT, ePortH + additionalSafetyH]);
            //usbPort middle
            translate([-usbPortOffset1, 0, usbPortHeightOffset])
                solid_block([usbPortW, containerWallT, usbPortH + additionalSafetyH]);
            //usbPort left
            translate([-usbPortOffset2, 0, usbPortHeightOffset])
                solid_block([usbPortW, containerWallT, usbPortH + additionalSafetyH]);
        }
        
        //locking mechanism
        lockOnFitOns();
    }
        
    //shaft fit ins
    shaftFitIns();
    
    
    }}
}

module Container_Top_Pins_Friendly(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    usbPortRemainingH = usbPortH - boardBotSideCompH + usbPortHeightOffset;
    height = containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortRemainingH;
    difference() {
        Container_Top();
        
        //Cover cutout
        translate([(-boardW+coverOpeningW)/2, (-boardL+coverOpeningL+shaftDiam)/2 + shaftLowerOffset, height - containerBaseH])
            solid_block([coverOpeningW, coverOpeningL, containerBaseH + 0.001]);
    }
    
    
    }}
}

module Container_Top_Open(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    acrylicCoverW = boardW + 2;
    acrylicCoverL = boardL;
    acrylicCoverH = 3.55;//containerBaseH + 0.001;
    hooksT = 0.7;
    hooksL = 6;
    hooksH = 1;
    translate(shift) { rotate(rotation) {
    
    
    usbPortRemainingH = usbPortH - boardBotSideCompH + usbPortHeightOffset;
    height = containerBaseH + boardBotH + boardH + usbPortHeightOffset + usbPortRemainingH;
    difference() {
        Container_Top();
        translate([0, 0, height - acrylicCoverH]) difference() {
            solid_block([acrylicCoverW, acrylicCoverL, acrylicCoverH + 0.001]);
            translate([(acrylicCoverW + boardW)/4, -(boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (hdmiL - mUsbL)/4, 0])
                solid_block([(acrylicCoverW - boardW)/2, portClearingL + 6, acrylicCoverH]);
        }
    }
    for (i = [-1 : 1]) for (j = [-1 : 2 : 1]) translate([j*acrylicCoverW/2, i*acrylicCoverL/3, height - hooksH])
        *#solid_block([hooksT, hooksL, hooksH], [-1*j*0.5, 0, 0.5]);
    
    
    
    }}
}

module Open_Top_Cover(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    acrylicCoverW = boardW + 2;
    acrylicCoverL = boardL;
    acrylicCoverH = 3.55;
    translate(shift) { rotate(rotation) {
    
    
    difference() {
        square([acrylicCoverW, acrylicCoverL], true);
        translate([(acrylicCoverW + boardW)/4, -(boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (hdmiL - mUsbL)/4])
            square([(acrylicCoverW - boardW)/2, portClearingL + 6], true);
        }
    
    
    }}
}

module Container_Bottom(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    height = containerBaseH + boardBotH + boardH + boardBotSideCompH;
    difference() {
        //full size
        union() {
            solid_block_chamfered([containerW, containerL, height], 1);
            translate([0, -(boardL+botLockAreaL)/2]) {
                for (i = [-1 : 2 : 1]) {
                    translate([i*boardW/4, 0])
                        solid_block([botLockAreaW, botLockAreaL, height]);
                }
            }
        }
        
        //inner volume cut out
        translate([0, 0, containerBaseH])
            solid_block([boardW, boardL, boardBotH + boardH + boardBotSideCompH]);
        
        //Right hand side components
        translate([(boardW+containerExtWT)/2, -(boardL)/2, containerBaseH + boardBotH + boardH]) {
            //mUsb
            mUsbHeightOffset = 0.6;
            translate([0, mUsbOffset, -mUsbHeightOffset])
                solid_block([containerExtWT, mUsbL, boardBotSideCompH + mUsbHeightOffset]);
            //hdmi
            translate([0, hdmiOffset, 0])
                solid_block([containerExtWT, hdmiL, hdmiH]);
            //aj
            translate([0, ajOffset, 0])
                solid_block([containerExtWT, ajL, ajH]);
        }
        
        //wall clearing
        translate([(boardW+containerExtWT+containerWallT)/2, -(boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (hdmiL - mUsbL)/4, 0])
            solid_block([containerExtWT - containerWallT, portClearingL, height]);
        
        //Top side components
        translate([(boardW)/2, (boardL+containerWallT)/2, containerBaseH + boardBotH + boardH]) {
            //ePort
            translate([-ePortOffset, 0, 0])
                solid_block([ePortW, containerWallT, ePortH]);
            //usbPort middle
            translate([-usbPortOffset1, 0, usbPortHeightOffset])
                solid_block([usbPortW, containerWallT, usbPortH]);
            //usbPort left
            translate([-usbPortOffset2, 0, usbPortHeightOffset])
                solid_block([usbPortW, containerWallT, usbPortH]);
        }
        
        //SD Card port
        translate([0, (-containerL+containerWallT)/2, 0])
            solid_block([sdcPortW, containerWallT, containerBaseH + boardBotSideCompH]);
    }
    
    //SD Card additional walling
    translate([0, (-boardL+containerWallT)/2, 0])
        solid_block([sdcPortW + containerWallT*2, containerWallT, containerBaseH + boardBotSideCompH - sdcPortH]);
    
    //Locking mechanism
    lockOns([0, 0, height]);
    
    //Shafts
    shafts();
    }}
}

module shaftFitIns(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    height = shaftFitOnsH;
    safetyH = -0.02;
    sideSupportH = 8;
    translate([(boardW)/2 - shaftSideOffset, 0, -boardBotSideCompH - safetyH]) {
        //lower piece
        translate([0, (-boardL)/2 + shaftLowerOffset]) { difference() {
            union() {
                solid_cylinder([shaftDiam, shaftDiam, height + safetyH]);
                translate([shaftSideOffset/2+0.1, 0, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftSideOffset+0.2, shaftDiam, sideSupportH]);
                translate([0, -shaftSideOffset/2-0.1, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftDiam, shaftSideOffset+0.2, sideSupportH]);
            }
            translate([0, 0, boardBotSideCompH + safetyH + lockOnsFitH + sideSupportH])
                solid_block([shaftDiam+0.1, shaftDiam+0.1, height - sideSupportH - boardBotSideCompH - lockOnsFitH]);
            *solid_cylinder([shaftFitOnsInDiam, shaftFitOnsInDiam, shaftInnerH]);
        }}
        
        //upper piece
        translate([0, (-boardL)/2 + shaftUpperOffset]) { difference() {
            union() {
                solid_cylinder([shaftDiam, shaftDiam, height + safetyH]);
                translate([shaftSideOffset/2+0.1, 0, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftSideOffset+0.2, shaftDiam, sideSupportH]);
            }
            translate([0, 0, boardBotSideCompH + safetyH + lockOnsFitH + sideSupportH])
                solid_block([shaftDiam+0.1, shaftDiam+0.1, height - sideSupportH - boardBotSideCompH - lockOnsFitH]);
            *solid_cylinder([shaftFitOnsInDiam, shaftFitOnsInDiam, shaftInnerH]);
        }}
    }
    translate([(-boardW)/2 + shaftSideOffset, 0, -boardBotSideCompH - safetyH]) {
        //lower piece
        translate([0, (-boardL)/2 + shaftLowerOffset]) { difference() {
            union() {
                solid_cylinder([shaftDiam, shaftDiam, height + safetyH]);
                translate([-shaftSideOffset/2-0.1, 0, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftSideOffset+0.2, shaftDiam, sideSupportH]);
                translate([0, -shaftSideOffset/2-0.1, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftDiam, shaftSideOffset+0.2, sideSupportH]);
            }
            translate([0, 0, boardBotSideCompH + safetyH + lockOnsFitH + sideSupportH])
                solid_block([shaftDiam+0.1, shaftDiam+0.1, height - sideSupportH - boardBotSideCompH - lockOnsFitH]);
            *solid_cylinder([shaftFitOnsInDiam, shaftFitOnsInDiam, shaftInnerH]);
        }}
        
        //upper piece
        translate([0, (-boardL)/2 + shaftUpperOffset]) { difference() {
            union() {
                solid_cylinder([shaftDiam, shaftDiam, height + safetyH]);
                translate([-shaftSideOffset/2-0.1, 0, boardBotSideCompH + safetyH + lockOnsFitH])
                    solid_block([shaftSideOffset+0.2, shaftDiam, sideSupportH]);
            }
            translate([0, 0, boardBotSideCompH + safetyH + lockOnsFitH + sideSupportH])
                solid_block([shaftDiam+0.1, shaftDiam+0.1, height - sideSupportH - boardBotSideCompH - lockOnsFitH]);
            *solid_cylinder([shaftFitOnsInDiam, shaftFitOnsInDiam, shaftInnerH]);
        }}
    }
    
    
    }}
}

module shafts(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    
    translate([(boardW)/2 - shaftSideOffset, 0, 0]) {
        //lower piece
        translate([0, (-boardL)/2 + shaftLowerOffset]) {
            solid_cylinder([shaftDiam, shaftDiam, containerBaseH + boardBotSideCompH]);
            *solid_cylinder([shaftInnerDiam, shaftInnerDiam, shaftInnerH]);
        }
        
        //upper piece
        translate([0, (-boardL)/2 + shaftUpperOffset]) {
            solid_cylinder([shaftDiam, shaftDiam, containerBaseH + boardBotSideCompH]);
            *solid_cylinder([shaftInnerDiam, shaftInnerDiam, shaftInnerH]);
        }
    }
    translate([(-boardW)/2 + shaftSideOffset, 0, 0]) {
        //lower piece
        translate([0, (-boardL)/2 + shaftLowerOffset]) {
            solid_cylinder([shaftDiam, shaftDiam, containerBaseH + boardBotSideCompH]);
            *solid_cylinder([shaftInnerDiam, shaftInnerDiam, shaftInnerH]);
        }
        
        //upper piece
        translate([0, (-boardL)/2 + shaftUpperOffset]) {
            solid_cylinder([shaftDiam, shaftDiam, containerBaseH + boardBotSideCompH]);
            *solid_cylinder([shaftInnerDiam, shaftInnerDiam, shaftInnerH]);
        }
    }
    
    
    }}
}

module lockOns(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    width = lockOnsW;
    length = lockOnsL;
    height = lockOnsH;
    
    //right side
    rightShift = (boardW+width)/2;
    translate([rightShift, (-boardL)/2 + 5*(mUsbOffset)/16])
        *solid_block([width, length, height]);
    translate([rightShift, (-boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (mUsbL-hdmiL)/4])
        *solid_block([width, length, height]);
    translate([rightShift, (-boardL)/2 + (hdmiOffset+ajOffset)/2 + (hdmiL-ajL)/4])
        *solid_block([width, length, height]);
    translate([rightShift, (boardL - ajOffset - ajL/2)/4 + ((-boardL)/2 + (ajOffset) + (ajL)/2)])
        solid_block([width, length, height]);
    translate([rightShift, 3*(boardL - ajOffset - ajL/2)/4 + ((-boardL)/2 + (ajOffset) + (ajL)/2)])
        solid_block([width, length, height]);
    
    //left side
    for (i = [0 : 4]) {
        translate([-(boardW+width)/2, (-boardL)/2 + i*boardL/5+boardL/10])
            solid_block([width, length, height]);
    }
    
    //bot side
    translate([0, -(boardL+width)/2]) {
        for (i = [-1 : 2 : 1]) {
            translate([i*boardW/4, 0])
                solid_block([length, width, height]);
        }
    }
    
    
    }}
}

module lockOnFitOns(shift = [0, 0, 0], rotation = [0, 0, 0]) {
    translate(shift) { rotate(rotation) {
    
    width = lockOnsFitW;
    length = lockOnsFitL;
    height = lockOnsFitH;
    
    //right side
    rightShift = (boardW+width)/2;
    translate([rightShift, (-boardL)/2 + 5*(mUsbOffset)/16])
        *solid_block([width, length, height]);
    translate([rightShift, (-boardL)/2 + (mUsbOffset+hdmiOffset)/2 + (mUsbL-hdmiL)/4])
        *solid_block([width, length, height]);
    translate([rightShift, (-boardL)/2 + (hdmiOffset+ajOffset)/2 + (hdmiL-ajL)/4])
        *solid_block([width, length, height]);
    translate([rightShift, (boardL - ajOffset - ajL/2)/4 + ((-boardL)/2 + (ajOffset) + (ajL)/2)])
        solid_block([width, length, height]);
    translate([rightShift, 3*(boardL - ajOffset - ajL/2)/4 + ((-boardL)/2 + (ajOffset) + (ajL)/2)])
        solid_block([width, length, height]);
    
    //left side
    for (i = [0 : 4]) {
        translate([-(boardW+width)/2, (-boardL)/2 + i*boardL/5+boardL/10])
            solid_block([width, length, height]);
    }
    
    //bot side
    translate([0, -(boardL+width)/2]) {
        for (i = [-1 : 2 : 1]) {
            translate([i*boardW/4, 0])
                solid_block([length, width, height]);
        }
    }
    
    
    }}
}

module solid_cylinder(dimensions) { //diamLower, diamUpper, height
    translate([0, 0, dimensions[2]/2])
        cylinder(dimensions[2], d1= dimensions[0], d2 = dimensions[1], center = true, $fn = 100);
}

module solid_block(dimensions, offsetRatio = [0, 0, 0.5], rotation = [0, 0, 0]) {
    translate([offsetRatio[0]*dimensions[0], offsetRatio[1]*dimensions[1], offsetRatio[2]*dimensions[2]]) rotate(rotation)
        cube(dimensions, true);
    //translate([0, 0, dimensions[2]/2])
    //    cube(dimensions, true);
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