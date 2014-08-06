//
//  MenuViewController.m
//  glkitTemplateGit
//
//  Created by Omar on 8/5/14.
//  Copyright (c) 2014 omar. All rights reserved.
//

#import "MenuViewController.h"
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

@interface MenuViewController ()

@end

@implementation MenuViewController

GLuint programHandle;
GLuint vertexBuffer;
GLuint vao;
GLuint vertexBufferName;
GLuint normalBufferName;



float triangleCoords[] = {
    
    0.0f, 0.0f,
    0.50f, 0.0f,
    0.50f, 0.10f,
    
    0.0f, 0.0f,
    0.0f, 0.10f,
    0.50f, 0.10f,
    
    
};


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ///  Setting the gesture
    
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; // 1
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; // 2
    view.context = context; // 3
    view.delegate = self; // 4
    
    
    
    //view.enableSetNeedsDisplay = NO;
    //CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    //[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil]; // 1
    viewController.view = view; // 2
    viewController.delegate = self; // 3
    viewController.preferredFramesPerSecond = 60; // 4
    [self addChildViewController:viewController] ; // 5
    [self.view addSubview:view];
    
    [EAGLContext setCurrentContext:context];//sete el contex
    
    glClearColor(1.0, 0.0, 0.0, 1.0);
    
    [self compileShaders];
     [self setupVBOs];
    //   glm::mat4 model=glm::rotate(glm::mat4(1.0f), 90.0f, glm::vec3(1.0,0,0.0));
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f );
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferName);
    glUseProgram(programHandle);
    glBindVertexArrayOES(vao);
    // Points
    glDrawArrays(GL_LINE_LOOP, 0, 6);
    
    //glDrawElements(GL_TRIANGLES, 3*mesh.numTriangles,GL_UNSIGNED_INT, mesh.indices);
    
   }

-(void) glkViewControllerUpdate:(GLKViewController *)controller
{
    
}

- (void)compileShaders {
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"  withType:GL_FRAGMENT_SHADER];
    
    // 2
    programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    // _positionSlot = glGetAttribLocation(programHandle, "Position");
    //  _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    //  glEnableVertexAttribArray(_positionSlot);
    //  glEnableVertexAttribArray(_colorSlot);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int) [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}



- (void)setupVBOs {
    
    vertexBuffer=0;
    vao=0;
    
    //VAO
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);
    //VAO
    
    
    //VBO
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleCoords), triangleCoords, GL_STATIC_DRAW);//copy data
    glVertexAttribPointer( glGetAttribLocation(programHandle, "Position") , 2, GL_FLOAT, GL_FALSE, 0, NULL);//define how to use the data of the up, how the gpu will read the data, offset where the divice start reading the data
    glEnableVertexAttribArray(0);
    //VBO
    
    //VAO
    glBindVertexArrayOES(0);
    //VAO
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Loading shader files from bundle



#pragma mark - Bundle stuff

//const char *pathForBundleResource(const char *filename)
//{
//    NSString *shaderNameStr = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
//
//    NSString *baseShaderName = [shaderNameStr stringByDeletingPathExtension];
//    NSString *shaderExtension = [shaderNameStr pathExtension];
//
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *path = [bundle pathForResource:baseShaderName ofType:shaderExtension];
//
//    const char *cPath = [path UTF8String];
//
//    return cPath;
//}

#pragma mark - OpenGL diagnostics

//static void printGLString(const char *name, GLenum s) {
//    const char *v = (const char *) glGetString(s);
//    NSLog(@"GL %s = %s\n", name, v);
//}

void checkGlError(const char* op)
{
    for (GLint error = glGetError(); error; error
         = glGetError()) {
        NSLog(@"after %s() glError (0x%x)\n", op, error);
    }
}

#pragma mark - OpenGLES Shader loading






@end
