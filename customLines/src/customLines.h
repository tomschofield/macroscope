/***************
customLines
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __customLines__
#define __customLines__

#include "ofMain.h"


using namespace std;




class customLines{
public:
    ofPoint thisCircle;
    vector<ofPoint> attachedCircles;
    void setup(ofPoint startPos,vector<ofPoint> otherStartPos );
    void update(ofPoint startPos,vector<ofPoint> otherStartPos );
 
 
    
};

#endif

