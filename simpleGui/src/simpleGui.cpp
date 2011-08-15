#include "simpleGui.h"


// I was finding about preprocessor instructions here: http://www.cplusplus.com/doc/tutorial/preprocessor/


////////////////////////---------/////////////////////////////////////
void simpleGui::setup(int mx, int my, int mw, int mh, string mname, ofImage picm){
    x=mx;
    y=my;
    w=mw;
    h=mh;
    name=mname;
    myCounter=0;
    myfont.loadFont(ofToDataPath("verdana.ttf"), 12, true);
    startPos=1;
    pic=picm;
    on =false;
}
////////////////////////---------/////////////////////////////////////
void simpleGui::checkToggle(int tX, int tY){
    if(tX>x && tX<x+w && tY> y && tY<y+h){
        on =!on;
    
    }
        
    
}

void simpleGui::drawButton(){
    ofSetLineWidth(1);

    if(on){
        ofSetColor(0,170,203,150);
    }
    else{  
        ofSetColor(0,125,154,150);
    }
    ofFill();
    ofRect(x,y,w,h);
    //pic.draw(x,y);
     ofSetColor(255,200);
    ofNoFill();
     ofRect(x-1,y-1,w+2,h+2);
    
    myfont.drawString(name,x,y+h+25);
    
    
}