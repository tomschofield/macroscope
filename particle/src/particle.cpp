#include "particle.h"


// I was finding about preprocessor instructions here: http://www.cplusplus.com/doc/tutorial/preprocessor/


////////////////////////---------/////////////////////////////////////
void particle::setup(){
    myCounter=0;
    myfont.loadFont("verdana.ttf", 12, true);
    startPos=1;
    alive=true;
    
    hasSearchTerm=false;
    
}
////////////////////////---------/////////////////////////////////////
void particle::drawWords(){
    
    
}

////////////////////////---------/////////////////////////////////////
void particle::drawCircle(){
    ofFill();
    ofSetColor(0);
    ofCircle(x, y, 27);
   // ofNoFill();
    if (hasSearchTerm) {
       ofSetColor(0,170,203,150);
    }
    else{
        
        ofSetColor(200,200);

    }
    ofCircle(x, y, 27);
    ofFill();
    ofSetColor(0);
    ofCircle(x, y, 22);
    
}
void particle::setupText(){
    string allWords="";
    
    string line;
    string myPath=ofToDataPath(title)+".txt";
    cout<<myPath<<" myPath\n";
    ifstream myfile (myPath.c_str());
    if (myfile.is_open())
    {
        while ( myfile.good() )
        {
            getline (myfile,line);
            cout << line << endl;
            //textContent.push_back(line);
            allWords+=line+" ";
            
        }
        myfile.close();
    }
    textContent=ofSplitString(allWords,".");
    
}
void particle::displaySignifWords() {
    //if(alive) {
        //TODO reset to strart of array
        int numToDisplay=10;
        int alphaShift=200;
        int transparency=1;
        
            int yShift=15;
            for(int i=startPos;i<startPos+numToDisplay;i++) {
                ofSetColor(220,alphaShift/transparency);
               
                   myfont.drawString(sigWords[i],x,y+yShift);
                
                
                yShift+=12;
                
                alphaShift-=255/numToDisplay;
            }
        
        if(myCounter%40==0) {
            startPos++;
        }
        if(startPos>=sigWords.size()-(1+numToDisplay)) {
            startPos=0;
        }
  //  }
    myCounter++;
}