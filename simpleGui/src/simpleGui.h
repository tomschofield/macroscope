/***************
simpleGui
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __simpleGui__
#define __simpleGui__

#include "ofMain.h"


using namespace std;


class simpleGui{
    public:
    int myVariable;
    int x,y,w,h;
    string name;
    ofTrueTypeFont myfont;
    vector<string> sigWords;
    vector<float>   attractionForces;
    string title;
     int myCounter;
    int startPos;
    void checkToggle(int tX, int tY);
    void setup(int mx, int my, int mw, int mh, string mname, ofImage picm);
    void drawButton();
    bool on;
    ofImage pic;
    
};

#endif

