/***************
SIMPLE PARTICLE
 //cc. non commercial share alike Tom Schofield, Source Code licenced under GNU v3 2011
*****************/

#ifndef __particle__
#define __particle__

#include "ofMain.h"


using namespace std;


class particle{
    public:
    int myVariable;
    int x,y;
    ofTrueTypeFont myfont;
    vector<string> sigWords;
    vector<float>   attractionForces;
    string title;
    bool alive;
     int myCounter;
    int startPos;
    void drawWords();
    void setup();
    void displaySignifWords();
    //private:
   
    
    
};

#endif

