//
//  GLPadEasing.h
//  iShoppingIPadLib
//
//  Created by guowenlong on 14-3-6.
//
//

#ifndef GL_EASING_H
#define GL_EASING_H

#ifdef GL_EASING_USE_DBL_PRECIS
#define GLFloat double
#else
#define GLFloat float
#endif

typedef GLFloat (*GLPadEasingFunction)(GLFloat);

// Overshooting cubic easing; 
GLFloat BackEaseIn(GLFloat p);
GLFloat BackEaseOut(GLFloat p);
GLFloat BackEaseInOut(GLFloat p);

#endif