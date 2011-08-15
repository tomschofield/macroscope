#include "testApp.h"
#include <iostream>
#include <fstream>

ofxiPhoneKeyboard *keyboard;
//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	const char* dirString = [documentsDirectory cStringUsingEncoding:NSASCIIStringEncoding];
    cout<<dirString<<" dir string \n";
	// initialize the accelerometer
	ofxAccelerometer.setup();
	ofImage tempBut;
    tempBut.loadImage("titles.png");
    
    butPics.push_back(tempBut);
    tempBut.loadImage("words.png");
    
     butPics.push_back(tempBut);
    tempBut.loadImage("destroy.png");
     butPics.push_back(tempBut);
    tempBut.loadImage("relocate.png");
     butPics.push_back(tempBut);
    
    
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    string buttonNames[4]={"show titles", "show words","destroy", "relocate"};
    float spacer=120;
    for(int i=0;i<4;i++){
    simpleGui tempButton;
        
        tempButton.setup(10, 50+ (spacer*i), 200,100, buttonNames[i], butPics[i]);
        buttons.push_back(tempButton);
    }
    
	buttons[3].on=true;
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofEnableAlphaBlending();
    ofEnableSmoothing();
    
    for (int i = 0; i < sizeof(keyboards)/sizeof(*keyboards); i++)
	{
		keyboards[i] = new ofxiPhoneKeyboard(0,52,320,32);
		keyboard = *keyboards;
		deviceOrientationChanged(i);
	}
 
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
           // if(i!=j){
                ofxBox2dJoint joint;
                joint.setWorld(box2d.getWorld());
            //joint.indexOfJoint=indCount;
                float thisAttraction=particles[i].attractionForces[j];
                joint.addJoint(circles[i].body, circles[j].body,.6,.9, true, ofMap(thisAttraction,0,30,0,20));
                tempVec.push_back(joint);
                joints.push_back(joint);
            //}
            indCount++;
        }
        cout<<tempVec.size()<<"temo vec size\n";
       // joints1.push_back(tempVec);
        
    }
  
}

//--------------------------------------------------------------
void testApp::update(){
    box2d.update();
    for (int i=0; i<NUM_SHAPES; i++) {
        particles[i].x=circles[i].getPosition().x;
        particles[i].y=circles[i].getPosition().y;
        
    }
  //  cout<<keyboard->getText()<<" key input\n";
   }

//--------------------------------------------------------------
void testApp::draw(){
    ofBackground(0, 0, 0);
    ofSetColor(255, 0, 0);
   
    //for(int i=0; i<3; i++) {
    for(int i=0; i<joints.size(); i++) {
        if (particles[i].alive==true) {
           joints[i].draw();
       }
	}
    
    /*for(int i=0; i<joints1.size(); i++) {
        for(int j=0; j<joints1[i].size(); j++) {
           
          //  joints1[i][j].draw();
        }
    }*/
     
    for(int i=0; i<circles.size(); i++) {
       if (particles[i].alive==true) {
           circles[i].draw();
           ofSetColor(255, 0, 0);
                //if(buttons[0].on){
                        //font.drawString(particles[i].title,circles[i].getPosition().x,circles[i].getPosition().y);
           if(buttons[0].on){
           font.drawString(ofToString(i)+" "+particles[i].title,circles[i].getPosition().x,circles[i].getPosition().y);
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
    for(int i=0;i<buttons.size();i++){
        
    buttons[i].checkToggle(touch.x,touch.y);
    }
    if (buttons[2].on) {
        buttons[3].on=false;
    }
    if (buttons[3].on) {
        buttons[2].on=false;
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
     if(buttons[2].on){
         
         //find nearest particle
         
         int minDist=2000000;
         int markedForDeath;
         for(int i=0;i<circles.size();i++){
             
             float thisDist=  ofDist(touch.x, touch.y, circles[i].getPosition().x,circles[i].getPosition().y );
             if (thisDist<minDist) {
                 minDist=thisDist;
                 markedForDeath=i;
             }
             
         }
         
         
    
    
    
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
    
     }
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

}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

