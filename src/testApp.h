#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxBox2d.h"
#include "ofxVectorMath.h"
#include "ofxXmlSettings.h"
#include "particle.h"
#include "simpleGui.h"
#include "customLines.h"

#define NUM_SHAPES 10

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
    
    
    void searchForWord();
    ofxBox2d						box2d;			  //	the box2d world
	vector		<ofxBox2dCircle>	circles;		  //	default box2d circles
  //  vector		<ofxBox2dBaseShape>	shapes;		  //	default box2d circles
    vector		<ofxBox2dJoint>	joints;
    vector <vector<ofxBox2dJoint> >	joints1;
    string NSStringToString(NSString * str);  
    vector<string> fileTxt;  
    ofTrueTypeFont font;
   // ofxiPhoneKeyboard * keyboard;
     //ofxiPhoneKeyboard * keyboard = [NSURL URLWithString:urlString];
    
    ofxiPhoneKeyboard *keyboards[UIDeviceOrientationFaceDown+1];
    ofxXmlSettings xml;
    vector<particle> particles;
    vector<simpleGui> buttons;
    vector<customLines> lines;
  //  void buttonChooser(int x, int y, int w, int h, string name);
    int destRel;
    int searchX, searchY, searchW, searchH;
    float contextX;
    string searchString;
    string context;
    vector <ofImage> butPics;
    bool keyboardHasToggled;
    bool previousKeyboardState;

};


