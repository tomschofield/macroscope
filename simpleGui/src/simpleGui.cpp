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
    myfont.loadFont("verdana.ttf", 12, true);
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
    ofSetColor(255,0,100);
    }
    else{
        
        ofSetColor(155,0,250);
    }
    ofFill();
    //ofRect(x,y,w,h);
    pic.draw(x,y);
     ofSetColor(255);
   // myfont.drawString(name,x,y+h+15);
    
    
}