#include "testApp.h"
#include <iostream>
#include <fstream>

ofxiPhoneKeyboard *keyboard;

//TODO fix the links, add search, make circles smaller, make nicer buttons
//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
    
    cout<<ofGetWidth()<<"width is\n";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	keyboardHasToggled=false;
    previousKeyboardState=false;
	const char* dirString = [documentsDirectory cStringUsingEncoding:NSASCIIStringEncoding];
    cout<<dirString<<" dir string \n";
	// initialize the accelerometer
	ofxAccelerometer.setup();
	ofImage tempBut;
    tempBut.loadImage("titles.png");
  
//     ofRect(49, 30, 322, 36);
    searchX=49;
    searchY=30;
    searchW=322;
    searchH=36;
    contextX=50;
    
    butPics.push_back(tempBut);
    tempBut.loadImage("words.png");
    
     butPics.push_back(tempBut);
    tempBut.loadImage("destroy.png");
     butPics.push_back(tempBut);
    tempBut.loadImage("relocate.png");
     butPics.push_back(tempBut);
    font.loadFont(ofToDataPath("verdana.ttf"), 12, true);
    
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    string buttonNames[2]={"show titles", "show words"};
    float spacer=120;
    for(int i=0;i<2;i++){
    simpleGui tempButton;
        
        tempButton.setup(50, spacer+50+ (spacer*i), 50,50, buttonNames[i], butPics[i]);
        buttons.push_back(tempButton);
    }
    
	//buttons[3].on=true;
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT);
	
	ofEnableAlphaBlending();
    ofEnableSmoothing();
    
  /*  for (int i = 0; i < sizeof(keyboards)/sizeof(*keyboards); i++)
	{
		keyboards[i] = new ofxiPhoneKeyboard(0,52,320,32);
		keyboard = *keyboards;
		deviceOrientationChanged(i);
	}*/
    int keyboardWidth=320;
    keyboard = new ofxiPhoneKeyboard( ofGetWidth()-keyboardWidth-50 ,ofGetHeight()-32,keyboardWidth,32);
	keyboard->setVisible(false);
	keyboard->setBgColor(0,170,203,100);
	keyboard->setFontColor(255,255,255, 200);
	keyboard->setFontSize(26);
 
    box2d.init();
	box2d.setGravity(0, 0);
	box2d.createBounds();
	
	box2d.setFPS(30.0);
	box2d.registerGrabbing();
    
    font.loadFont("verdana.ttf", 12, true);
    
    string tagNames[NUM_SHAPES]={"displays", "historical_rights","interfacing", "links", "manovich", "p1903-fischer", "p299-dourish", "poster_complubot_soccer_light_2011", "visualisation", "why_graph"};
    string message;
 
    if( xml.loadFile("art.xml") ){
		message = "mySettings.xml loaded!";
	}else{
		message = "unable to load mySettings.xml check data/ folder";
	}
    
    cout<<message<<" is\r";
    int numTags=xml.getNumTags("STROKE");
    cout<<numTags<<" is the number of tags\n";
    xml.setVerbose("true");
    xml.pushTag("STROKE");
 
    for(int i=0;i<NUM_SHAPES;i++){
        particle tempParticle;
            cout<<tagNames[i]<<" TAGNAMES\n";
            vector<string> names;
            xml.getAttributeNames(tagNames[i],names,0);
            //start populating the particle class
            tempParticle.title=tagNames[i];
            vector<string>tempWords;
            vector<float>forces;
        
            for(int j=0;j<names.size();j++){
                string contents=xml.getAttribute(tagNames[i],names[j],"nothing",0);
                //cout<<names[j]<<" = "<<contents<<"  \n";
                if (names[j].substr(0,8)=="sigWords") {
                    //cout<<contents<<"this exists\n";
                   //  cout<<names[j].substr(8,10)<<"this exists\n";
                    tempWords.push_back(contents);
                }
                if (names[j].substr(0,15)=="attractionForce") {
                    //cout<<names[j].substr(16,18)<<" attraction forces at "<<i<<" is "<<contents<<"\n";
                    forces.push_back(ofToFloat(contents));
                }
            }
        tempParticle.sigWords=tempWords;
        tempParticle.attractionForces=forces;
        tempParticle.setup();
        particles.push_back(tempParticle);
    
    }
    
    xml.popTag();
    
    for(int j=0;j<NUM_SHAPES;j++){
        vector<float>invertedForces;
            for(int i=0;i<NUM_SHAPES;i++){
                    invertedForces.push_back(particles[j].attractionForces[(NUM_SHAPES-1)-i]);
                    cout<<particles[0].attractionForces[i]<<" forces\n";  
                }
        particles[j].attractionForces=invertedForces;
    }
	
    for(int i=0; i<NUM_SHAPES; i++) {
		//float r = ofRandom(4, 20);
		ofxBox2dCircle circle;
		circle.setPhysics(1.0, 0.5, 0.2);
        circle.setup(box2d.getWorld(), ofRandom(ofGetWidth()), ofRandom(ofGetHeight()), 40);
		circles.push_back(circle);
	}
    int indCount=0;
    for(int i=0; i<NUM_SHAPES; i++) {
        //create an empty vector of joints
        vector<ofxBox2dJoint> tempVec;
        
        for(int j=0; j<NUM_SHAPES; j++) {
            
            //dont draw a joint between a particle and itself
            if(i!=j){
                ofxBox2dJoint joint;
                joint.setWorld(box2d.getWorld());
                //joint.indexOfJoint=indCount;
                float thisAttraction=particles[i].attractionForces[j];
                joint.addJoint(circles[i].body, circles[j].body,.6,.9, true, ofMap(thisAttraction,0,30,0,20));
                tempVec.push_back(joint);
                joints.push_back(joint);
            }
            indCount++;
        }
        cout<<tempVec.size()<<"temo vec size\n";
       // joints1.push_back(tempVec);
        
    }
    for(int i=0;i<particles.size();i++){
        particles[i].setupText();
    }
}

//--------------------------------------------------------------
void testApp::update(){
    box2d.update();
    contextX-=2;
    //if the keyboard state has changed
    if(previousKeyboardState!=keyboard->isKeyboardShowing()){
        //to off
        if(!keyboard->isKeyboardShowing()){
            context="";
            contextX=50;
            searchString=keyboard->getLabelText();
             cout<<searchString<<" searchString\n";
                searchForWord();
            // inititate search here!
            
        }
        
    }

   
    
    for (int i=0; i<NUM_SHAPES; i++) {
        particles[i].x=circles[i].getPosition().x;
        particles[i].y=circles[i].getPosition().y;
        
    }
  //  cout<<keyboard->getText()<<" key input\n";

    previousKeyboardState=keyboard->isKeyboardShowing();
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0, 0, 0);
    ofPushStyle();
    ofNoFill();
    ofSetColor(255, 150);
    ofRect(searchX,searchY, searchW,searchH);
    font.drawString("enter search word", 50, 30+36+25);
    font.drawString(context,contextX, 130);
    ofPopStyle();
    for(int i=0; i<particles.size(); i++) {
     
        for(int j=0; j<particles.size();j++) {
              float thisAttraction=particles[i].attractionForces[j];
            ofSetLineWidth( ofMap(thisAttraction,0,30,0,15));
             ofSetColor(100, 100, 100,ofMap(thisAttraction,0,30,0,120));
             if (particles[i].alive==true&&particles[j].alive==true) {
                 ofLine(particles[i].x, particles[i].y, particles[j].x, particles[j].y);
             }
            
        }
        
    }
     ofSetColor(255, 0, 0);
    for(int i=0; i<circles.size(); i++) {
       if (particles[i].alive==true) {
           //circles[i].draw();
           particles[i].drawCircle();
           ofSetColor(255,200);
                //if(buttons[0].on){
                        //font.drawString(particles[i].title,circles[i].getPosition().x,circles[i].getPosition().y);
           if(buttons[0].on){
           font.drawString(particles[i].title,circles[i].getPosition().x,circles[i].getPosition().y);
               // }
         }
	}
     }
    if(buttons[1].on){
        
    for (int i=0; i<NUM_SHAPES; i++) {
         if (particles[i].alive==true) {
        particles[i].displaySignifWords();
            }
         }
    }
	//box2d.draw(); // used to draw the floor
    for (int i=0; i<buttons.size(); i++) {
        buttons[i].drawButton();
    }
	
}

//--------------------------------------------------------------
void testApp::exit(){

}


//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    
  //  if (touch.id == 1){
    if(touch.x>searchX && touch.x<searchX+searchW && touch.y>searchY && touch.y<searchY+searchH){
		if(!keyboard->isKeyboardShowing()){
			keyboard->openKeyboard();
			keyboard->setVisible(true);
		}	
		
	}
    
    
    for(int i=0;i<buttons.size();i++){
        
    buttons[i].checkToggle(touch.x,touch.y);
    }
   
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
    // if(buttons[2].on){
         
         //find nearest particle
         
         int minDist=2000000;
         int markedForDeath;
         
         //find the nearest particle
         for(int i=0;i<circles.size();i++){
             
             float thisDist=  ofDist(touch.x, touch.y, circles[i].getPosition().x,circles[i].getPosition().y );
             if (thisDist<minDist) {
                 minDist=thisDist;
                 markedForDeath=i;
             }
             
         }
         
         
    
         particles[markedForDeath].alive=false;
    
    vector <ofxBox2dCircle>::iterator iter = circles.begin();
    
    // vector <ofxBox2dJoint>::iterator iter1 = joints1.begin();
    int count=0;
    vector <ofxBox2dJoint> tempJoints;
    int aliveCounter=0;
    
         
         while (iter != circles.end()) {
		//iter->draw();
		if (count==markedForDeath) {
            int thiscount=0;
            
            //this is a hack
            
            
            for(int j=0;j<NUM_SHAPES*2;j++){   
                vector <ofxBox2dJoint>::iterator iter1 = joints.begin();
                for(b2JointEdge *s=iter->body-> GetJointList(); s; s=s->next) {
                    b2Joint* thisjoint=s->joint;
                    thisjoint->isAlive=false;
                    iter->body->GetWorld()->DestroyJoint(thisjoint);
                    joints.erase(iter1);
                    thiscount++;
                }
                ++iter1;
                
                aliveCounter++;
            }
            
            //  box2d.world->DestroyBody(iter->body);  
            // iter = customParticles.erase(iter);
            // circles[count].destroyShape();
            // box2d.world->DestroyBody(iter->body); 
            //  iter = circles.erase(iter);
            
            
            
		}
		++iter;
        
        count++;
        aliveCounter++;
	}
    cout<<joints.size()<<" is the size of joints\n";
    cout<<circles.size()<<" is the size of circles\n";
    
     //}
}

//--------------------------------------------------------------
void testApp::searchForWord(){
    context="";
    //for each particle
    for(int i=0;i<particles.size();i++){
        particles[i].hasSearchTerm=false;
        if (particles[i].alive) {
             //look in each sentence
            for (int j=0; j<particles[i].textContent.size(); j++) {
                //at each word
                vector<string>thisSentence = ofSplitString(particles[i].textContent[j]," ");
                for(int k=0;k<thisSentence.size();k++){
                    if(searchString==thisSentence[k]){
                        
                        //add to hit list
                        context+=particles[i].textContent[j]+" ";
                        particles[i].hasSearchTerm=true;
                    }
                    
                    
                }
                
            }
        
   
    
    
    
    //if you get a match add to the hit list and mark that particle as bearing the mark
        }
    }
    keyboard->setText("");
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    cout<<newOrientation<<" new orientation \n";
    switch(newOrientation){
        case 3:
                 ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_LEFT);
            break;
        case 4:
                   ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
            break;
    }
    keyboard->updateOrientation();
}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

