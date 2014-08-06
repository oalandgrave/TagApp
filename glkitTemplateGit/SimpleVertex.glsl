//
//  Shader.vsh
//  Vibora
//
//  Created by Omar on 7/21/14.
//  Copyright (c) 2014 omar. All rights reserved.
//

attribute vec4 Position; // 1
uniform mat4 model;
uniform mat4 projection;
uniform mat4 view;


void main(void) { // 4
//    DestinationColor = SourceColor; // 5
    
   
    
        gl_Position =Position; // 6
        
    
 //   gl_Position.xy=xform*Position.xy;
}